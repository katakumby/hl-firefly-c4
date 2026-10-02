-- ============================================================
-- BIBLIOTEKA — ORACLE DATABASE 21c
-- Skrypt przeznaczony do uruchomienia w pustym schemacie.
-- ============================================================

CREATE TABLE Autorzy (
    id_autora NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    imie      VARCHAR2(100 CHAR) NOT NULL,
    nazwisko  VARCHAR2(150 CHAR) NOT NULL,

    CONSTRAINT pk_autorzy PRIMARY KEY (id_autora)
);


CREATE TABLE Dziedziny (
    id_dziedziny           NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    nazwa                  VARCHAR2(150 CHAR) NOT NULL,
    id_dziedziny_nadrzednej NUMBER(10),

    CONSTRAINT pk_dziedziny PRIMARY KEY (id_dziedziny),

    CONSTRAINT fk_dziedziny_nadrzedna
        FOREIGN KEY (id_dziedziny_nadrzednej)
        REFERENCES Dziedziny (id_dziedziny),

    CONSTRAINT ck_dziedziny_nie_sobie CHECK (
        id_dziedziny_nadrzednej IS NULL
        OR id_dziedziny_nadrzednej <> id_dziedziny
    )
);


CREATE TABLE Wydawnictwa (
    id_wydawnictwa NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    nazwa          VARCHAR2(200 CHAR) NOT NULL,
    kraj           VARCHAR2(100 CHAR) NOT NULL,
    miejscowosc    VARCHAR2(100 CHAR) NOT NULL,
    kod_pocztowy    VARCHAR2(20 CHAR) NOT NULL,
    ulica          VARCHAR2(150 CHAR),
    numer_budynku  VARCHAR2(20 CHAR) NOT NULL,
    numer_lokalu   VARCHAR2(20 CHAR),

    CONSTRAINT pk_wydawnictwa PRIMARY KEY (id_wydawnictwa)
);


CREATE TABLE Dziela (
    id_dziela            NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    tytul                VARCHAR2(500 CHAR) NOT NULL,
    id_dziedziny         NUMBER(10) NOT NULL,
    id_autora_wymaganego NUMBER(10) NOT NULL,

    CONSTRAINT pk_dziela PRIMARY KEY (id_dziela),

    CONSTRAINT fk_dziela_dziedzina
        FOREIGN KEY (id_dziedziny)
        REFERENCES Dziedziny (id_dziedziny)
);


-- Tabela lacznikowa realizujaca relacje wiele do wielu.
CREATE TABLE Autorstwo (
    id_dziela NUMBER(10) NOT NULL,
    id_autora NUMBER(10) NOT NULL,

    CONSTRAINT pk_autorstwo
        PRIMARY KEY (id_dziela, id_autora),

    CONSTRAINT fk_autorstwo_dzielo
        FOREIGN KEY (id_dziela)
        REFERENCES Dziela (id_dziela),

    CONSTRAINT fk_autorstwo_autor
        FOREIGN KEY (id_autora)
        REFERENCES Autorzy (id_autora)
);


-- Kazde dzielo musi miec co najmniej jednego autora.
-- Wskazany autor musi nalezec do autorow TEGO SAMEGO dziela.
-- Ograniczenie sprawdzane domyslnie przy COMMIT.
ALTER TABLE Dziela
    ADD CONSTRAINT fk_dziela_autor_wymagany
        FOREIGN KEY (id_dziela, id_autora_wymaganego)
        REFERENCES Autorstwo (id_dziela, id_autora)
        DEFERRABLE INITIALLY DEFERRED;


CREATE TABLE Wydania (
    id_wydania     NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    id_dziela      NUMBER(10) NOT NULL,
    id_wydawnictwa NUMBER(10) NOT NULL,
    rok_wydania    NUMBER(4) NOT NULL,
    numer_wydania  NUMBER(4) DEFAULT 1 NOT NULL,
    numer_isbn     VARCHAR2(13 CHAR),

    CONSTRAINT pk_wydania PRIMARY KEY (id_wydania),

    CONSTRAINT fk_wydania_dzielo
        FOREIGN KEY (id_dziela)
        REFERENCES Dziela (id_dziela),

    CONSTRAINT fk_wydania_wydawnictwo
        FOREIGN KEY (id_wydawnictwa)
        REFERENCES Wydawnictwa (id_wydawnictwa),

    CONSTRAINT uq_wydania_isbn UNIQUE (numer_isbn),

    CONSTRAINT ck_wydania_rok
        CHECK (rok_wydania BETWEEN 1 AND 9999),

    CONSTRAINT ck_wydania_numer
        CHECK (numer_wydania > 0),

    -- ISBN zapisujemy bez spacji i lacznikow.
    -- Kontrola formatu, nie cyfry kontrolnej.
    CONSTRAINT ck_wydania_isbn CHECK (
        numer_isbn IS NULL
        OR REGEXP_LIKE(
            numer_isbn,
            '^([0-9]{9}[0-9X]|[0-9]{13})$',
            'c'
        )
    )
);


CREATE TABLE Egzemplarze (
    id_egzemplarza     NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    id_wydania        NUMBER(10) NOT NULL,
    numer_inwentarzowy VARCHAR2(40 CHAR) NOT NULL,

    CONSTRAINT pk_egzemplarze PRIMARY KEY (id_egzemplarza),

    CONSTRAINT uq_egzemplarze_numer
        UNIQUE (numer_inwentarzowy),

    CONSTRAINT fk_egzemplarze_wydanie
        FOREIGN KEY (id_wydania)
        REFERENCES Wydania (id_wydania)
);


CREATE TABLE Czytelnicy (
    id_czytelnika NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    numer_karty   VARCHAR2(30 CHAR) NOT NULL,
    imie          VARCHAR2(100 CHAR) NOT NULL,
    nazwisko      VARCHAR2(150 CHAR) NOT NULL,
    adres_email   VARCHAR2(254 CHAR),

    CONSTRAINT pk_czytelnicy PRIMARY KEY (id_czytelnika),

    CONSTRAINT uq_czytelnicy_karta UNIQUE (numer_karty)
);


-- Jeden wiersz oznacza jedno wypozyczenie jednego egzemplarza.
CREATE TABLE Wypozyczenia (
    id_wypozyczenia   NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    id_egzemplarza    NUMBER(10) NOT NULL,
    id_czytelnika     NUMBER(10) NOT NULL,
    data_wypozyczenia DATE DEFAULT SYSDATE NOT NULL,
    data_zwrotu       DATE,

    CONSTRAINT pk_wypozyczenia PRIMARY KEY (id_wypozyczenia),

    CONSTRAINT fk_wypozyczenia_egzemplarz
        FOREIGN KEY (id_egzemplarza)
        REFERENCES Egzemplarze (id_egzemplarza),

    CONSTRAINT fk_wypozyczenia_czytelnik
        FOREIGN KEY (id_czytelnika)
        REFERENCES Czytelnicy (id_czytelnika),

    CONSTRAINT ck_wypozyczenia_daty CHECK (
        data_zwrotu IS NULL
        OR data_zwrotu >= data_wypozyczenia
    )
);


-- Najwyzej jedno niezakończone wypozyczenie egzemplarza.
CREATE UNIQUE INDEX uq_wypozyczenia_otwarte
    ON Wypozyczenia (
        CASE
            WHEN data_zwrotu IS NULL THEN id_egzemplarza
        END
    );


-- ============================================================
-- INDEKSY POMOCNICZE
-- ============================================================

CREATE INDEX ix_dziedziny_nadrzedna
    ON Dziedziny (id_dziedziny_nadrzednej);

CREATE INDEX ix_dziela_dziedzina
    ON Dziela (id_dziedziny);

CREATE INDEX ix_dziela_autor_wymagany
    ON Dziela (id_dziela, id_autora_wymaganego);

CREATE INDEX ix_autorstwo_autor
    ON Autorstwo (id_autora);

CREATE INDEX ix_wydania_dzielo
    ON Wydania (id_dziela);

CREATE INDEX ix_wydania_wydawnictwo
    ON Wydania (id_wydawnictwa);

CREATE INDEX ix_egzemplarze_wydanie
    ON Egzemplarze (id_wydania);

CREATE INDEX ix_wypozyczenia_egzemplarz
    ON Wypozyczenia (id_egzemplarza, data_wypozyczenia);

CREATE INDEX ix_wypozyczenia_czytelnik
    ON Wypozyczenia (id_czytelnika, data_wypozyczenia);