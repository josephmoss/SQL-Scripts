-- Adapted from https://stackoverflow.com/questions/18106947/cte-recursion-to-get-tree-hierarchy

CREATE TABLE tblLocations (ID INT IDENTITY(1,1), ParentID INT, Name VARCHAR(20));

INSERT INTO tblLocations ( ParentID, Name) VALUES
(NULL, 'West'),
(1, 'WA'),
(2, 'Seattle'),
(NULL, 'East'),
(4, 'NY'),
(5, 'New York'),
(1, 'NV'),
(7, 'Las Vegas'),
(2, 'Vancouver'),
(4, 'FL'),
(5, 'Buffalo'),
(1, 'CA'),
(10, 'Miami'),
(12, 'Los Angeles'),
(7, 'Reno'),
(12, 'San Francisco'),
(10, 'Orlando'),
(12, 'Sacramento');

-- Stack Overflow Example
;WITH MyCTE AS (
  SELECT ID, Name, 0 AS TreeLevel, CAST(ID AS VARCHAR(255)) AS TreePath
  FROM tblLocations T1
  WHERE ParentID IS NULL

  UNION ALL

  SELECT T2.ID, T2.Name, TreeLevel + 1, CAST(TreePath + '.' + CAST(T2.ID AS VARCHAR(255)) AS VARCHAR(255)) AS TreePath
  FROM tblLocations T2
  INNER JOIN MyCTE itms ON itms.ID = T2.ParentID
)
-- Note: The 'replicate' function is not needed. Added it to give a visual of the results.
SELECT ID, Replicate('.', TreeLevel * 4)+Name 'Name', TreeLevel, TreePath
FROM  MyCTE 
ORDER BY TreePath;


;WITH MyTest as --OUR EXAMPLE
(
	SELECT C.ID, C.ParentID, CAST(C.Name AS VARCHAR(255)) as Level, 0 as Depth
	from tblLocations C
	UNION ALL
	
	SELECT 
		C1.id,  
		C1.ParentID,  CAST(M.Level + ' -> ' + CAST(C1.Name AS VARCHAR(255)) AS VARCHAR(255)) , Depth + 1
	from tblLocations C1
	INNER JOIN MyTest M
	ON M.Id = C1.ParentId
)
select * from MyTest
