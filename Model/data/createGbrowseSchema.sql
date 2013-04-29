-- This SQL script can be used both to create a GBROWSE_USERS schema
-- and to create the necessary tables and sequence for allowing session
-- and account management for WDK users in Oracle.

CREATE USER GBROWSE_USERS
  IDENTIFIED BY gbUsersDummyPassword;

GRANT create session TO GBROWSE_USERS;
GRANT create table TO GBROWSE_USERS;
GRANT create view TO GBROWSE_USERS;
GRANT create any trigger TO GBROWSE_USERS;
GRANT create any procedure TO GBROWSE_USERS;
GRANT create sequence TO GBROWSE_USERS;
GRANT create synonym TO GBROWSE_USERS;

CREATE TABLE GBROWSE_USERS.DBINFO (
    "SCHEMA_VERSION" NUMBER
);

INSERT INTO GBROWSE_USERS.DBINFO ( SCHEMA_VERSION ) VALUES ( 4 );

CREATE TABLE GBROWSE_USERS.OPENID_USERS (
    "USERID"     NUMBER,
    "OPENID_URL" VARCHAR2(128 BYTE) NOT NULL ENABLE,
    CONSTRAINT "OPENID_USERS_PK" PRIMARY KEY ("OPENID_URL")
);

CREATE TABLE GBROWSE_USERS.SESSION_TBL (
    "USERID"    NUMBER NOT NULL ENABLE,
    "UPLOADSID" VARCHAR2(32 BYTE),
    "SESSIONID" VARCHAR2(32 BYTE),
    "USERNAME"  VARCHAR2(32 BYTE),
    CONSTRAINT "SESSION_TBL_PK" PRIMARY KEY ("USERID")
);

CREATE TABLE GBROWSE_USERS.SESSIONS (
    "ID" VARCHAR2(32 BYTE) NOT NULL ENABLE,
    "A_SESSION" LONG NOT NULL ENABLE,
    CONSTRAINT "SESSIONS_PK" PRIMARY KEY ("ID")
);

CREATE TABLE GBROWSE_USERS.SHARING (
    "USERID"    NUMBER,
    "IS_PUBLIC" NUMBER,
    "TRACKID"   VARCHAR2(32 BYTE)
);

CREATE TABLE GBROWSE_USERS.UPLOADS (
    "USERID"         NUMBER,
    "SHARING_POLICY" VARCHAR2(36 BYTE),
    "DESCRIPTION" CLOB,
    "TRACKID" VARCHAR2(32 BYTE) NOT NULL ENABLE,
    "MODIFICATION_DATE" DATE,
    "CREATION_DATE" DATE,
    "PUBLIC_COUNT" NUMBER,
    "IMPORTED"     NUMBER,
    "PATH"         VARCHAR2(1024 BYTE),
    "DATA_SOURCE"  VARCHAR2(1024 BYTE),
    "TITLE"        VARCHAR2(1024 BYTE),
    CONSTRAINT "UPLOADS_PK" PRIMARY KEY ("TRACKID")
);

CREATE TABLE GBROWSE_USERS.USERS (
    "LAST_LOGIN" DATE,
    "PASS"     VARCHAR2(50 BYTE),
    "USERID"   NUMBER NOT NULL ENABLE,
    "REMEMBER" NUMBER,
    "CREATED" DATE,
    "EMAIL"       VARCHAR2(64 BYTE),
    "OPENID_ONLY" NUMBER,
    "CONFIRMED"   NUMBER,
    "GECOS"       VARCHAR2(64 BYTE),
    "CNFRM_CODE"  VARCHAR2(32 BYTE),
    CONSTRAINT "USERS_PK" PRIMARY KEY ("USERID")
);

CREATE SEQUENCE GBROWSE_USERS.GBROWSE_UID_SEQ
    MINVALUE 1 MAXVALUE 9999999999999999999999999999
    INCREMENT BY 1 START WITH 1
    NOCACHE NOORDER NOCYCLE;
