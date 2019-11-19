// MySQL naming convention

DROP PROCEDURE IF EXISTS SP_Name;
DELIMITER //

CREATE DEFINER = 'deployer'@'%' PROCEDURE  SP_Name(
	//IN Parameters Definition,
	//OUT Parameters Definition
	)
    /*
		Creator: creator@YYYYMMDD
        Parameters Explanation:
			-
			
        Revisions:
			-
		
    */
)
SQL SECURITY DEFINER
BEGIN
	INSERT INTO UserLog_RunSP(LogTime, ActionID, ReferenceID, UserID, LogContent, Duration)
    SELECT logTime, actionID, referenceID, userID, logContent, duration;
END;

//
DELIMITER ;
GRANT EXECUTE ON PROCEDURE SP_Name TO 'executer'@'%';