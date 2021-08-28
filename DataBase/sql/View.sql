/**
* part3: ������ͼ
* �������û��˶��ɾ���ͼ���û����������ͼ��
*
*/

USE BI;
-- �����û��˶��ɾ���ͼ������UserSportTrack�ľۺϣ�
--CREATE VIEW V_UserSportAchiv AS (
-- SELECT UserId, SportType, SUM(Duration) AS Total_Duration, SUM(Amount) AS Total_Amount, SUM(Amount) * AVG(Consuming) AS Total_Consuming FROM (
--  SELECT t1.UserId, t1.SportType, t1.StartTime, t1.Duration, t1.Amount, t2.Consuming, t2.Unit FROM UserSportTrack t1 LEFT JOIN Sport t2 ON t1.SportType = t2.SportType) t
-- GROUP BY UserId, SportType
--);

-- �û����������ͼ
	-- ���½���״����ͼ
CREATE VIEW V_UserCurrHealth AS(
 SELECT UserId, Height, Weight, BodyFatRate, CAST(CAST(Weight AS float)/CAST(Height AS FLOAT)/Height*10000 AS decimal(3,1))AS BMI 
 FROM UserInfo x 
 WHERE WriteInDate = (SELECT MAX(WriteInDate) FROM UserInfo y WHERE x.UserId = y.UserId) 
 );

	-- ���¾ۺϽ���״����ͼ
CREATE VIEW V_UserMonthHealth AS(
	SELECT UserId, LEFT(WriteInDate,7) AS 'Month', 
	AVG(Height) AS 'Height', 
	AVG(Weight) AS 'Weight', 
	AVG(BodyFatRate) AS 'BodyFatRate',
	CAST(CAST(AVG(Weight) AS float)/CAST(AVG(Height) AS FLOAT)/AVG(Height)*10000 AS decimal(3,1))AS BMI
	FROM UserInfo 
	GROUP BY UserId,LEFT(WriteInDate,7)
);

-- �û�ÿ���˶���ͼ�����������ġ����˶�ʱ������Ԫ���ġ�֬�������ֶΣ�
CREATE VIEW V_UserDailySport AS(
	SELECT UserId, WriteInDate, 
	CAST (SUM(Duration) AS INT) AS Daily_Duration, 
	CAST( SUM(AvgConsuming*Duration*Tensity) AS INT)AS Daily_Consuming,
	SUM(Sugar_Consuming) AS Daily_SugarConsuming,
	SUM(Fat_Consuming) AS Daily_FatConsuming
	FROM (
		SELECT UserId, WriteInDate, Duration, Tensity, AvgConsuming, 
		(0.6 - CAST(Duration AS FLOAT)/100*0.2) * AvgConsuming * Tensity*Duration AS Sugar_Consuming,
		(0.4 +CAST(Duration AS FLOAT)/100*0.2) * AvgConsuming * Tensity*Duration AS Fat_Consuming
		FROM UserSportTrack x 
		LEFT JOIN Sport y 
		ON x.SportType = y.SportType
	) T
	GROUP BY UserId, WriteInDate
);


-- �û�7�����˶���ͼ��7�������˶�ʱ����7���������ģ�
CREATE VIEW V_UserWeeklySport AS (
	SELECT UserId, 
	SUM(Daily_Duration) AS Weekly_Duration, 
	SUM(Daily_Consuming) AS Weekly_Consuming 
	FROM V_UserDailySport 
	WHERE DateDiff(dd,WriteInDate,getdate())<=7 
	GROUP BY UserId
);


-- �û�-�˶���ͼ(GROUP BY uesrId,Sport�� ͳ��ÿ���˶��Ĵ�����ÿ���˶���ʱ�䣬��·��)
CREATE VIEW V_SportAggr AS (
	SELECT UserId, SportType, 
	COUNT(*) AS cnt, 
	SUM(Duration) AS Total_Duration,
	SUM(Consuming) AS Total_Consuming
	FROM (
		SELECT UserId, x.SportType, Duration, Tensity * AvgConsuming AS Consuming
		FROM UserSportTrack x 
		LEFT JOIN Sport y 
		ON x.SportType = y.SportType
	) T
	GROUP BY UserId, SportType
);

-- �û���ʳ��ͼ��ÿ������������(KCal)���ܿ���(g)���ܵ�����(g)����̼ˮ(g)����֬��(g))
CREATE VIEW V_DiteDaily AS(
	SELECT UserId, IntakeDate, 
	SUM(IntakeAmount) AS Daily_Amt,
	SUM(Energy_Intake) AS Daily_Energy, 
	SUM(Protein_Intake) AS Daily_Protein,
	SUM(Carbohydrate_Intake) AS Daily_carb,
	SUM(Fat_Intake) AS Daily_Fat 
	FROM(
		SELECT UserId, IntakeDate, x.FoodName,IntakeAmount, 
		(SugarRate*IntakeAmount*4 + IntakeAmount * Energy) AS Energy_Intake,
		IntakeAmount * Protein AS Protein_Intake,
		(SugarRate*IntakeAmount*1.0 + IntakeAmount*Carbohydrate) AS Carbohydrate_Intake,
		IntakeAmount * Fat AS Fat_Intake
		FROM UserDite x LEFT JOIN Food y ON x.FoodName  =y.FoodName
	) T
	GROUP BY UserId, IntakeDate
);