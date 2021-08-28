-- ����BodyIntelligence���ݿ�
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'BI') DROP DATABASE BI;
CREATE DATABASE BI;
-- ָ�����ݿ�
USE BI;

/**
* Part1: ϵͳ����̨����
* ����: �˶���ʽ���ɾͻ��±�ʳ����Ϣ��
*
*/

-- �����˶���ʽ��
 -- Unit��ʾ��λ������������
 -- Consuming��ʾ���ǵ�λʱ��(/min)�µ�ƽ�����ģ���λ��kCal
CREATE TABLE Sport(
 SportType VARCHAR(30) NOT NULL,
 AvgConsuming FLOAT NOT NULL,
 PRIMARY KEY (SportType)
);

-- �ɾͻ��±�
CREATE TABLE Achievement(
 SportType VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Sport(SportType),
 Level1 VARCHAR(255),
 Level2 VARCHAR(255),
 Level3 VARCHAR(255),
 PRIMARY KEY (SportType)
);

-- ʳ����Ϣ��
CREATE TABLE Food(
 FoodName VARCHAR(30) NOT NULL,
 Energy FLOAT NOT NULL,
 Protein FLOAT NOT NULL,
 Carbohydrate FLOAT NOT NULL,
 Fat FLOAT NOT NULL,
 Descript VARCHAR(255),
 PRIMARY KEY (Foodname)
);

/**
* Part2: �û����û�����
* ����: �û��˺ű��û��������ݱ��û���ʳ���û��˶���Ϊ��
*
*/

-- �����û��˺ű�
CREATE TABLE UserAccount(
 UserId VARCHAR(20) NOT NULL CHECK(LEN(UserId) BETWEEN 6 AND 20 AND UserId LIKE '[A-Za-z0-9]%'),
 UserPwd VARCHAR(20) NOT NULL CHECK(LEN(UserPwd) BETWEEN 6 AND 20 AND UserPwd LIKE '[A-Za-z0-9]%'),
 UserName VARCHAR(30) NOT NULL,
 Icon VARCHAR(255),
 PRIMARY KEY (UserId)
);

-- �����û��������ݱ�
CREATE TABLE UserInfo(
 UserId VARCHAR(20) CHECK(LEN(UserId) BETWEEN 6 AND 20 AND UserId LIKE '[A-Za-z0-9]%') FOREIGN KEY REFERENCES UserAccount(UserId),
 WriteInDate DATE NOT NULL,
 Height INT NOT NULL,
 Weight INT NOT NULL,
 BodyFatRate INT,
 PRIMARY KEY (UserId, WriteInDate)
);

-- �����û���ʳ��
	-- intakeAmount��λ����

CREATE TABLE UserDite(
 UserId VARCHAR(20) CHECK(LEN(UserId) BETWEEN 6 AND 20 AND UserId LIKE '[A-Za-z0-9]%') FOREIGN KEY REFERENCES UserAccount(UserId),
 FoodName VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Food(FoodName),
 IntakeDate Date NOT NULL,
 IntakeAmount FLOAT NOT NULL,
 SugarRate FLOAT CHECK(SugarRate IN (0, 0.1, 0.2, 0.3))
 PRIMARY KEY (UserId, FoodName, IntakeDate)
);

-- �û��˶���Ϊ��
 -- Duration: /min
 -- Amount������Sport�����Unit��Ϊ������λ
CREATE TABLE UserSportTrack(
 UserId VARCHAR(20) CHECK(LEN(UserId) BETWEEN 6 AND 20 AND UserId LIKE '[A-Za-z0-9]%') FOREIGN KEY REFERENCES UserAccount(UserId),
 SportType VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES Sport(SportType),
 WriteInDate DATE NOT NULL,
 Duration SMALLINT NOT NULL,
 Tensity FLOAT CHECK(Tensity IN (0.7,1,1.3)),
 PRIMARY KEY (UserId, SportType, WriteInDate)
);

/**
* part5: ��������
* ������
*
*/
INSERT INTO UserAccount (UserId, UserPwd, UserName) VALUES
('100001','123456','admin'),
('User_Theo','123456','Theo'),
('User_Felix','123456','Felix')
;

INSERT INTO UserInfo VALUES
('100001','2021-06-10',181,70,21),
('100001','2021-05-10',181,72,22),
('100001','2021-04-10',180,75,23),
('100001','2021-03-10',180,80,26),
('100001','2021-02-10',180,76,22),
('100001','2021-01-10',180,71,19),
('100001','2020-12-10',180,73,21)
;


INSERT INTO Sport VALUES
('�ܲ�', 8),
('����', 6),
('��Ӿ', 8),
('����', 9),
('����', 9),
('����', 9),
('��ë��', 8.5),
('����', 7.2),
('ƹ����', 6),
('���ɻ', 4)
;

INSERT INTO Food (FoodName, Energy, Protein, Carbohydrate, Fat) VALUES
('��������',3.46,0.06,0.72,0.009),
('����決',3.12,0.08,0.6,0.05),
('��������',4,0.13,0.02,0.35),
('��Ϻ����',1.2,0.16,0.04,0.05),
('����',1.44,0.14,0.03,0.08),
('�߲�',0.1,0.01,0.01,0.003),
('ˮ��',0.5,0,0.1,0),
('ţ��',0.6,0.03,0.03,0.03),
('��Ʒ',5,0.07,0.6,0.25),
('��֬',9,0,0,1),
('��',4,0,1,0)
;

INSERT INTO UserSportTrack VALUES
('100001','��Ӿ','2021-06-14',100,1),
('100001','�ܲ�','2021-06-13',50,1),
('100001','���ɻ','2021-06-13',120,0.7),
('100001','��Ӿ','2021-06-12',60,1.3),
('100001','����','2021-06-11',60,1),
('100001','�ܲ�','2021-06-11',30,1.3),
('100001','���ɻ','2021-06-10',30,1.3),
('100001','��Ӿ','2021-06-10',120,0.7),
('100001','����','2021-06-10',20,1.3),
('100001','����','2021-06-09',30,1.3),
('100001','��Ӿ','2021-06-08',100,1.3),
('100001','�ܲ�','2021-06-07',20,1),
('100001','����','2021-06-07',25,1),
('100001','��Ӿ','2021-06-06',60,0.7),
('100001','����','2021-06-05',60,1.3),
('100001','��Ӿ','2021-06-04',40,1.3),
('100001','�ܲ�','2021-06-04',30,1)
;


INSERT INTO UserDite VALUES
--
('100001', '��������', '2021-6-14', 200, 0.1),
('100001', '����決', '2021-6-14', 100, 0.3),
('100001', '��������', '2021-6-14', 200, 0.1),
('100001', 'ţ��', '2021-6-14', 200, 0.1),
('100001', '�߲�', '2021-6-14', 100, 0.1),
--
('100001', 'ˮ��', '2021-6-13', 200, 0.1),
('100001', 'ţ��', '2021-6-13', 200, 0),
('100001', '��������', '2021-6-13', 200, 0.1),
('100001', '����', '2021-6-13', 100, 0),
('100001', '��������', '2021-6-13', 400, 0.1),
--
('100001', '��������', '2021-6-12', 300, 0),
('100001', '��������', '2021-6-12', 100, 0.1),
('100001', '�߲�', '2021-6-12', 200, 0.1),
('100001', '����', '2021-6-12', 50, 0),
('100001', '��Ʒ', '2021-6-12', 100, 0.3),
--
('100001', '��������', '2021-6-11', 300, 0),
('100001', '��������', '2021-6-11', 200, 0.1),
('100001', '����', '2021-6-11', 100, 0),
('100001', '�߲�', '2021-6-11', 200, 0.1),
--
('100001', '��������', '2021-6-10', 100, 0),
('100001', 'ˮ��', '2021-6-10', 300, 0.1),
('100001', 'ţ��', '2021-6-10', 500, 0),
('100001', '��Ϻ����', '2021-6-10', 200, 0.1),
--
('100001', '����決', '2021-6-09', 200, 0.2),
('100001', '��������', '2021-6-09', 300, 0),
('100001', '�߲�', '2021-6-09', 300, 0),
('100001', 'ˮ��', '2021-6-09', 100, 0.1),
('100001', 'ţ��', '2021-6-09', 200, 0),
--
('100001', '��������', '2021-6-08', 300, 0.1),
('100001', '��������', '2021-6-08', 200, 0.1),
('100001', '�߲�', '2021-6-08', 100, 0.1),
('100001', '����', '2021-6-08', 100, 0),
('100001', '��Ʒ', '2021-6-08', 100, 0.3),
--
('100001', '��������', '2021-6-07', 100, 0),
('100001', '����決', '2021-6-07', 300, 0.2),
('100001', '��������', '2021-6-07', 200, 0.1),
('100001', 'ţ��', '2021-6-07', 300, 0.1),
('100001', '�߲�', '2021-6-07', 200, 0.1)
;