DROP PROCEDURE IF EXISTS `Intg_LA_GetPromoSummary`;
DELIMITER //

CREATE DEFINER=`NPHP_admin`@`%` PROCEDURE `Intg_LA_GetPromoSummary`(
	IN winlostdate DATE
)
/*
	Creator: Bobby@20191119
	Parameters Explanation:
		- winlostdate DATE: The day to receive the summary report data
		
	Revisions:
		- 20191119@Bobby:  Generate SUM data fro LA reporting [RedmineID: #119417]
	
*/
SQL SECURITY DEFINER
BEGIN
	DECLARE winlostdateEnd DATE;
    
    SET winlostdateEnd = DATE_ADD(winlostdate, INTERVAL 1 DAY);
        
	select p.PromoID
		,p.StartDate
		,p.EndDate
		,p.OffPeakStartTime
		,p.OffPeakEndTime
		,c.CustID
		,c.CurrencyID
        ,CONVERT(c.CreateTime, DATE) AS CouponDate
        ,8 AS CouponTimeZone 
        ,CONVERT(ADDTIME(c.CreateTime, '12:00:00'), DATE) AS CouponDateGMT
		,COUNT(c.couponID) AS CouponCount
		,SUM(c.Redeemed) AS RedemptionCount
		,SUM(c.prize) AS RedemptionPrize
	from Promotion.NPHPromotion AS p
	left join Promotion.NPHPromoCoupon c ON p.PromoID = c.PromoID AND c.PromoDay = winlostdate
	where winlostdate >= p.startDate AND winlostdate <= p.enddate
	group by p.PromoID
		,p.StartDate
		,p.EndDate
		,p.OffPeakStartTime
		,p.OffPeakEndTime
		,c.CustID
		,c.CurrencyID
        ,CONVERT(c.CreateTime, DATE)
        ,CONVERT(ADDTIME(c.CreateTime, '12:00:00'), DATE)
	;
END;

//
DELIMITER ;
GRANT EXECUTE ON PROCEDURE Intg_LA_GetPromoSummary TO 'sqlLink'@'%';