"""Deterministic obstacle-aware deployment routes and separated label positions."""
import heapq,math

def route(v,elements,relationships):
    leaves={x['id']:x for x in v['elements'] if 'instances' not in elements[x['id']]}
    heights={i:360 if 'Person' in elements[i].get('tags','').split(',') else 220 for i in leaves}
    bottom=145 if 'environment' in v else 25
    boxes={i:(x['x']-25,x['y']-25,x['x']+385,x['y']+heights[i]+bottom) for i,x in leaves.items()}
    centers={i:(x['x']+180,x['y']+heights[i]//2) for i,x in leaves.items()}
    xs=sorted({c[0]+d for c in centers.values() for d in (-310,0,310)}|{150})
    ys=sorted({c[1]+d for c in centers.values() for d in (-260,0,380)}|{150})
    xs=[x for x in xs if x>100];ys=[y for y in ys if y>100]
    xi={x:i for i,x in enumerate(xs)};yi={y:i for i,y in enumerate(ys)}
    segments=[];labels=[]
    def collision(a,b):return min(a[2],b[2])>max(a[0],b[0]) and min(a[3],b[3])>max(a[1],b[1])
    def crossed(a,b,box):
        x1,y1=a;x2,y2=b;l,t,r,d=box
        if x1==x2:return l<x1<r and min(y1,y2)<d and max(y1,y2)>t
        return t<y1<d and min(x1,x2)<r and max(x1,x2)>l
    # Short local dataflows first, then longer cross-zone and infrastructure edges.
    def dist(rv):
        r=relationships[rv['id']];a=centers[r['sourceId']];b=centers[r['destinationId']]
        return abs(a[0]-b[0])+abs(a[1]-b[1])
    for rv in sorted(v['relationships'],key=dist):
        r=relationships[rv['id']];sid=r['sourceId'];did=r['destinationId'];s=centers[sid];d=centers[did]
        obstacles=[box for id,box in boxes.items() if id not in (sid,did)]
        start=(xi[s[0]],yi[s[1]],-1);goal=(xi[d[0]],yi[d[1]])
        queue=[(0,0,start)];costs={start:0};prev={};edge_cache={};end=None
        while queue:
            _,cost,state=heapq.heappop(queue)
            if cost!=costs.get(state):continue
            ix,iy,di=state
            if (ix,iy)==goal:end=state;break
            a=(xs[ix],ys[iy])
            for nx,ny,nd in ((ix-1,iy,0),(ix+1,iy,0),(ix,iy-1,1),(ix,iy+1,1)):
                if nx<0 or nx>=len(xs) or ny<0 or ny>=len(ys):continue
                b=(xs[nx],ys[ny]);edge=(a,b)
                if edge not in edge_cache:
                    blocked=any(crossed(a,b,box) for box in obstacles)
                    # Enter and leave endpoints along one straight axis. A bend inside
                    # a source/destination box would draw a line through its label.
                    for eid,center,outgoing in ((sid,s,True),(did,d,False)):
                        node=leaves[eid];body=(node['x'],node['y'],node['x']+360,node['y']+heights[eid])
                        if crossed(a,b,body):
                            aligned=(a[0]==b[0]==center[0]) or (a[1]==b[1]==center[1])
                            before=abs(a[0]-center[0])+abs(a[1]-center[1]);after=abs(b[0]-center[0])+abs(b[1]-center[1])
                            if not aligned or (after<=before if outgoing else after>=before):blocked=True
                    penalty=0
                    if not blocked:
                        for pa,pb in segments:
                            if nd==0 and pa[1]==pb[1]==a[1] and min(b[0],a[0])<max(pa[0],pb[0]) and max(a[0],b[0])>min(pa[0],pb[0]):penalty+=1200
                            elif nd==1 and pa[0]==pb[0]==a[0] and min(b[1],a[1])<max(pa[1],pb[1]) and max(a[1],b[1])>min(pa[1],pb[1]):penalty+=1200
                    edge_cache[edge]=(blocked,penalty)
                blocked,penalty=edge_cache[edge]
                if blocked:continue
                nc=cost+abs(a[0]-b[0])+abs(a[1]-b[1])+penalty+(180 if di not in (-1,nd) else 0)
                ns=(nx,ny,nd)
                if nc<costs.get(ns,math.inf):
                    costs[ns]=nc;prev[ns]=state;h=abs(b[0]-d[0])+abs(b[1]-d[1]);heapq.heappush(queue,(nc+h,nc,ns))
        if end is None:raise RuntimeError('No deployment route: '+v['key']+'/'+rv['id'])
        path=[];cur=end
        while True:
            path.append((xs[cur[0]],ys[cur[1]]))
            if cur==start:break
            cur=prev[cur]
        path.reverse();simple=[path[0]]
        for a,b,c in zip(path,path[1:],path[2:]):
            if (a[0]==b[0])!=(b[0]==c[0]):simple.append(b)
        simple.append(path[-1]);segments.extend(zip(simple,simple[1:]))
        rv['vertices']=[{'x':x,'y':y} for x,y in simple[1:-1]]
        rv['routing']='Direct';rv['jump']=False
        # The renderer clips the endpoints at node boundaries; mirror that here.
        clip=list(simple)
        for idx,adj in ((0,1),(-1,-2)):
            x,y=clip[idx];ax,ay=clip[adj]
            half=heights[sid if idx==0 else did]/2
            clip[idx]=(x+(180 if ax>x else -180),y) if ax!=x else (x,y+(half if ay>y else -half))
        lengths=[abs(a[0]-b[0])+abs(a[1]-b[1]) for a,b in zip(clip,clip[1:])];total=sum(lengths)
        options=[]
        for percent in range(5,96):
            distance=total*percent/100;left=distance
            for j,length in enumerate(lengths):
                if left<=length or j==len(lengths)-1:
                    a,b=clip[j],clip[j+1];t=left/length if length else 0;x=a[0]+(b[0]-a[0])*t;y=a[1]+(b[1]-a[1])*t;break
                left-=length
            box=(x-145,y-85,x+145,y+85)
            count=sum(collision(box,nb) for nb in boxes.values())+sum(collision(box,lb) for lb in labels)
            options.append((count,abs(percent-50),percent,box))
        count,_,percent,box=min(options)
        if count:print('Label needs visual review:',v['key'],rv['id'],count)
        rv['position']=percent;labels.append(box)
    return v
