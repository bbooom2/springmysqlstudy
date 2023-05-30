-- 1게시글 - 1첨부 - 1테이블
-- 1게시글 - 다중첨부 - 2테이블

-- 다중 첨부 게시판

-- 스키마 
USE gdj61;

-- 테이블 삭제는 생성의 역순 
DROP TABLE IF EXISTS ATTACH;
DROP TABLE IF EXISTS UPLOAD;

-- 게시글 정보 테이블
CREATE TABLE UPLOAD (
    UPLOAD_NO      INT NOT NULL AUTO_INCREMENT,               -- PK
    UPLOAD_TITLE   VARCHAR(1000) NOT NULL,  -- 제목
    UPLOAD_CONTENT LONGTEXT NULL,                          -- 내용
    CREATED_AT     TIMESTAMP NULL,                     -- 작성일
    MODIFIED_AT    TIMESTAMP NULL                     -- 수정일
    CONSTRAINT PK_UPLOAD PRIMARY KEY(UPLOAD_NO)
);
-- 첨부 파일 정보 테이블
CREATE TABLE ATTACH (
    ATTACH_NO       INT NOT NULL AUTO_INCREMENT,              -- PK
    PATH            VARCHAR2(300) NOT NULL,  -- 첨부 파일 경로
    ORIGIN_NAME     VARCHAR2(300) NOT NULL,  -- 첨부 파일의 원래 이름
    FILESYSTEM_NAME VARCHAR2(50) NOT NULL,   -- 첨부 파일의 저장 이름
    DOWNLOAD_COUNT  INT,                       -- 다운로드 횟수
    HAS_THUMBNAIL   TINYINT,                       -- 썸네일이 있으면 1, 없으면 0
    UPLOAD_NO       INT                        -- 게시글 FK
    CONSTRAINT PK_ATTACH PRIMARY KEY(ATTACH_NO),
    CONSTRAINT FK_ATTACH_UPLOAD FOREIGN KEY(UPLOAD_NO) REFERENCES UPLOAD(UPLOAD_NO) ON DELETE CASCADE
);
