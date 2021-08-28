
/**
* part4: �洢���̡�������
* ������
*
*/
USE BI;

 -- ��ѯ�û�ĳһ����˶���ʱ�����˶�������
CREATE PROCEDURE GetDailySportRecord
@SelectedId varchar(100),
@SelectedDate varchar(100)
AS
BEGIN
	SELECT * FROM V_UserDailySport WHERE UserId = @SelectedId AND WriteInDate = @SelectedDate
end;

 -- ��ѯĳ�û��˶�ʱ���ֲ�
CREATE PROCEDURE GetSportTimeDistribute
@SelectId varchar(100)
AS
BEGIN
	SELECT UserId, TimeZone, COUNT(*) AS cnt FROM(
		SELECT 
		UserId,
		CASE(Duration/30)
			WHEN 0 THEN '0-30'
			WHEN 1 THEN '30-60'
		ELSE '60+' END AS TimeZone
		FROM UserSportTrack 
		WHERE UserId = @SelectId
	) T
	GROUP BY UserId,TimeZone
	ORDER BY TimeZone
END;

-- ��ѯĳ�û��˶�ǿ�ȷֲ�
CREATE PROCEDURE GetSportIntensityDistribute
@SelectedId varchar(100)
AS
BEGIN
	SELECT UserId, Tensity, COUNT(*) AS cnt FROM UserSportTrack GROUP BY UserId, Tensity HAVING UserId = @SelectedId
END;

-- ��ѯ�û���ʳ�����ֲ���������������������������
CREATE PROCEDURE GetDiteEnergyDistribute
@SelectedId varchar(100)
AS
BEGIN
	SELECT UserId, EnergyZone, COUNT(*) AS cnt FROM (
		SELECT UserId, 
		CASE 
			WHEN Daily_Energy < 1600 THEN '������'
			WHEN Daily_Energy BETWEEN 1600 AND 2400 THEN '������'
			WHEN Daily_Energy > 2400 THEN '������'
		END AS EnergyZone
		FROM V_DiteDaily WHERE UserId = @SelectedId
	) T
	GROUP BY UserId, EnergyZone
	ORDER BY cnt DESC
END;

-- ��ѯ�û���ʳӪ���ֲ�
CREATE PROCEDURE GetDiteNutriDistribute
@SelectedId varchar(100)
AS
BEGIN
	SELECT UserId,
		SUM(Daily_Protein) AS 'Total_Protein', 
		SUM(Daily_carb) AS 'Total_Carb', 
		SUM(Daily_Fat) AS 'Total_Fat' 
	FROM V_DiteDaily WHERE UserId = @SelectedId
	GROUP BY UserId
END;

-- ��ѯ��ʳ����ֲ������������ʳ������������������
CREATE PROCEDURE GetDiteTypeDistribute
@SelectedId varchar(100)
AS
BEGIN
	SELECT UserId, FoodName, SUM(IntakeAmount) AS 'Total_IntakeAmt', SUM(IntakeAmount*Energy) AS 'Total_Energy' FROM(
		SELECT UserId, x.FoodName, IntakeAmount, Energy
		FROM UserDite x LEFT JOIN Food y 
		ON x.FoodName  =y.FoodName
		WHERE UserId = @SelectedId
	) T
	GROUP BY UserId, FoodName
	ORDER BY Total_IntakeAmt DESC;
END;

-- ��ѯĳ�û�ĳ��Ļ���ָ������(��ȥ7��ƽ��ÿ���˶����ġ��и�ǿ���ܴ������и�ǿ���ܴ���)
CREATE PROCEDURE GetPaiAggr
@SelectedId varchar(100),
@SelectedDate varchar(100)
AS
BEGIN
	SELECT UserId, MAX(WriteInDate) AS SelectedDay ,AVG(Daily_Consuming) AS Latest7DaysAvgConcuming, SUM(�и�ǿ��) AS '�и�ǿ��', SUM(�е�ǿ��) AS '�е�ǿ��' FROM (
	SELECT UserId, WriteInDate, 
		CAST(SUM(AvgConsuming*Duration*Tensity) AS INT) AS Daily_Consuming,
		SUM(�и�ǿ��) AS '�и�ǿ��',
		SUM(�е�ǿ��) AS '�е�ǿ��'
		FROM (
			SELECT UserId, WriteInDate, Tensity, Duration, AvgConsuming,
				CASE WHEN Tensity IN (1.0,1.3) THEN 1 WHEN Tensity = 0.7 THEN 0 END AS '�и�ǿ��',
				CASE WHEN Tensity IN (1.0,0.7) THEN 1 WHEN Tensity = 1.3 THEN 0 END AS '�е�ǿ��'
			FROM UserSportTrack x 
			LEFT JOIN Sport y 
			ON x.SportType = y.SportType
		) T
	WHERE UserId = @SelectedId AND  DateDiff(dd,WriteInDate,@SelectedDate) BETWEEN 0 AND 6 
	GROUP BY UserId, WriteInDate
) T
GROUP BY UserId;
END;