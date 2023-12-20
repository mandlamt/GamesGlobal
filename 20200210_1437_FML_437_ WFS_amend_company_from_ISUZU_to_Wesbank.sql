
-- 2020-02-10 14:37M
-- MANDLA MTHOMBENI
-- FML-437, WFS - amend company from UDTRUCKS to Wesbank

declare @db varchar(100) = (select db_name());

if @db like 'FleetActiv_Wesbank%'
begin

		-- OLD DATA BELOW
		/*
		qdqm_fk_branch
		UDTRUCKS

		qdqm_dealfunder
		26 */
		PRINT ('BEFORE UPDATE.......');
		SELECT qdqm_fk_branch,qdqm_dealfunder,* FROM qdqm where  qdqm_quote=(select qddm_fk_quote from qddm where qddm_deal='0000112390');

		-- UPDATE qdqm SET qdqm_dealfunder=11 /*COMPANY*/ where  qdqm_quote=(select qddm_fk_quote from qddm where qddm_deal='0000112384');
		UPDATE qdqm SET qdqm_fk_branch='WESBANK3' /* BRANCH*/,qdqm_dealfunder=11 /*COMPANY*/ where  qdqm_quote=(select qddm_fk_quote from qddm where qddm_deal='0000112390');

		PRINT ('BEFORE UPDATE.......');
		SELECT qdqm_fk_branch,qdqm_dealfunder,* FROM qdqm where  qdqm_quote=(select qddm_fk_quote from qddm where qddm_deal='0000112390');

end
else begin
		print('wrong database!');
end

		