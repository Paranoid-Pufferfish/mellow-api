CREATE TABLE IF NOT EXISTS CAMPUSES
(
    CAMPUS_NAME TEXT UNIQUE NOT NULL
);
INSERT INTO CAMPUSES
VALUES ('El Kseur');
INSERT INTO CAMPUSES
VALUES ('Targa');
INSERT INTO CAMPUSES
VALUES ('Aboudaou');

CREATE TABLE IF NOT EXISTS BOOKS
(
    ISBN13       INTEGER NOT NULL,
    TITLE        TEXT    NOT NULL,
    AUTHOR       TEXT,
    PUBLISHER    TEXT,
    RELEASE_DATE DATE,
    COVER        TEXT,
    CAMPUS       INTEGER,
    AVAILABLE    BOOLEAN,
    FOREIGN KEY (CAMPUS) REFERENCES CAMPUSES (ROWID)
);
CREATE TABLE IF NOT EXISTS ACCOUNTS
(
    UUID            INTEGER PRIMARY KEY NOT NULL,
    ACC_PASSHASH    TEXT                NOT NULL,
    ACC_DISPLAYNAME TEXT                NOT NULL,
    ACC_ADMIN       BOOLEAN             NOT NULL,
    ACC_CAMPUS      INTEGER             NOT NULL,
    FOREIGN KEY (ACC_CAMPUS) REFERENCES CAMPUSES (rowid)
);
CREATE TABLE IF NOT EXISTS RENTEES
(
    MATRICULE          INTEGER PRIMARY KEY NOT NULL,
    RENTEE_DISPLAYNAME TEXT                NOT NULL,
    RENTEE_DEGREE      TEXT
);

CREATE TABLE IF NOT EXISTS CATEGORIES
(
    CATEGORY_NAME        TEXT NOT NULL,
    CATEGORY_DESCRIPTION TEXT
);

/* Associations */

CREATE TABLE IF NOT EXISTS BOOKS_CATEGORIES
(
    BOOK     INTEGER NOT NULL,
    CATEGORY INTEGER NOT NULL,
    FOREIGN KEY (BOOK) REFERENCES BOOKS (ROWID),
    FOREIGN KEY (CATEGORY) REFERENCES CATEGORIES (ROWID),
    UNIQUE (BOOK, CATEGORY)
);
CREATE TABLE IF NOT EXISTS INVENTORY
(
    RENTEE    INTEGER  NOT NULL,
    BOOK      INTEGER  NOT NULL,
    RENT_DATE DATETIME NOT NULL,
    UNIQUE (BOOK, RENTEE, RENT_DATE),
    FOREIGN KEY (RENTEE) REFERENCES RENTEES (MATRICULE),
    FOREIGN KEY (BOOK) REFERENCES BOOKS (ROWID)
);

CREATE TABLE IF NOT EXISTS LOGS
(
    ACTION_DATE     DATETIME NOT NULL,
    ACTION_TYPE     BOOLEAN  NOT NULL,
    SUBERVISING_ACC INTEGER  NOT NULL,
    RENTEE          INTEGER  NOT NULL,
    BOOK            INTEGER  NOT NULL,
    FOREIGN KEY (SUBERVISING_ACC) REFERENCES ACCOUNTS (UUID),
    FOREIGN KEY (BOOK) REFERENCES BOOKS (ROWID),
    FOREIGN KEY (RENTEE) REFERENCES RENTEES (MATRICULE)
);
