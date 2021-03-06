/* Học phần: Cơ sở dữ liệu
   Ngày: 02/05/2020
   Người thực hiện: LÊ SỸ HÙNG
*/
------------------------------------------------
--lệnh tạo CSDL
CREATE DATABASE LAB05_QUANLY_TOURDULICH
GO
-- lenh su dung 
USE LAB05_QUANLY_TOURDULICH
GO
--- tao bang----
CREATE TABLE TOUR
(
MaTOUR CHAR(4) PRIMARY KEY,
TongSoNgay INT
)
GO
CREATE TABLE ThanhPho
(
MaTP CHAR(2) PRIMARY KEY,
TenTP NVARCHAR(30)
)
GO
CREATE TABLE TOURTP
(
MaTOUR CHAR(4) REFERENCES TOUR(MaTOUR),
MaTP CHAR(2) REFERENCES ThanhPho(MaTP),
SoNgay INT,
PRIMARY KEY(MaTOUR,MaTP)
)
GO
CREATE TABLE Lich_TOURDL
(
MaTOUR CHAR(4) REFERENCES TOUR(MaTOUR),
NgayKH DATETIME,
TenHDV NVARCHAR(10),
SoNguoi INT,
TenKH NVARCHAR(30)
PRIMARY KEY (MaTOUR,NgayKH)
)
GO
SELECT*FROM TOUR
SELECT*FROM Lich_TOURDL
SELECT*FROM ThanhPho
SELECT*FROM TOURTP
GO
-----ham thu tuc --------
CREATE PROC usp_Insert_TOUR
@MaTOUR CHAR(4),@TongSoNgay INT
AS
IF EXISTS(SELECT*FROM TOUR WHERE MaTOUR = @MaTOUR)
	PRINT N'Đã có mã TOUR'+@MaTOUR+'trong CSDL.'
ELSE
	BEGIN
		INSERT INTO TOUR VALUES(@MaTOUR,@TongSoNgay)
		PRINT N'Thêm TOUR thanh cong.'
	END
GO
-- Goi thuc hien nhap TOUR
EXEC usp_Insert_TOUR 'T001',3
EXEC usp_Insert_TOUR 'T002',4
EXEC usp_Insert_TOUR 'T003',5
EXEC usp_Insert_TOUR 'T004',7
--- xem bang vua nhap-----
SELECT*FROM TOUR
GO
-- thu tuc nhap thanh pho-----
CREATE PROC usp_Insert_ThanhPho
@MaTP CHAR(2),@TenTP NVARCHAR(30)
AS
IF EXISTS(SELECT*FROM ThanhPho WHERE MaTP=@MaTP)
	PRINT N'Đã có mã Thanh Pho '+@MaTP+'trong CSDL.'
ELSE
	BEGIN
		INSERT INTO ThanhPho VALUES(@MaTP,@TenTP)
		PRINT N'Thêm Thanh Pho thanh cong.'
	END
GO
-- goi lênh nhap tp-----
EXEC usp_Insert_ThanhPho '01',N'Đà Lạt'
EXEC usp_Insert_ThanhPho '02',N'Nha Trang'
EXEC usp_Insert_ThanhPho '03',N'Phan Thiết'
EXEC usp_Insert_ThanhPho '04',N'Huế'
EXEC usp_Insert_ThanhPho '05',N'Đà Nẵng'
---- xem bang vua nhap -----
SELECT*FROM ThanhPho
GO
--- thu tuc ham nhap Tour_TP -----
CREATE PROC usp_Insert_TOURTP
	@MaTOUR CHAR(4),@MaTP CHAR(2),@SoNgay INT
AS
-- kiem tra khoa ngoai
IF EXISTS(SELECT*FROM TOUR WHERE MaTOUR=@MaTOUR)
	AND EXISTS(SELECT*FROM ThanhPho WHERE MaTP=@MaTP)
BEGIN
	IF EXISTS(SELECT*FROM TOURTP WHERE MaTOUR=@MaTOUR
	AND MaTP=@MaTP)
	PRINT N'Đã tồn Tại tour '+@MaTOUR+' '+@MaTP+'Trong CSDL.'
	ELSE
		BEGIN
			INSERT INTO TOURTP VALUES(@MaTOUR,@MaTP,@SoNgay)
			PRINT N'Thêm Tour_TP thành công.'
		END
END
ELSE
	IF NOT EXISTS(SELECT*FROM TOUR WHERE MaTOUR=@MaTOUR)
	PRINT N'không có TOUR'+ @MaTOUR +'TRong CSDL.'
	ELSE
	PRINT N'Không có Thanh Pho'+ @MaTP +'Trong CSDL.'
GO
-- goi thu tuc nhap bang ----
EXEC usp_Insert_TOURTP 'T001','01',2
EXEC usp_Insert_TOURTP 'T001','03',1
EXEC usp_Insert_TOURTP 'T002','01',2
EXEC usp_Insert_TOURTP 'T002','02',2
EXEC usp_Insert_TOURTP 'T003','02',2
EXEC usp_Insert_TOURTP 'T003','01',1
EXEC usp_Insert_TOURTP 'T003','04',2
EXEC usp_Insert_TOURTP 'T004','02',2
EXEC usp_Insert_TOURTP 'T004','05',2
EXEC usp_Insert_TOURTP 'T004','04',3
---- xem bang -----
SELECT*FROM TOURTP
GO
--- THU tuc Lich tourDL--------
CREATE PROC usp_Insert_Lich_TOURDL
	@MaTOUR CHAR(4),@NgayKH DATETIME,@TenHDV NVARCHAR(10),
@SoNguoi INT,@TenKH NVARCHAR(30)
AS
-- kiem tra khoa ngoai
IF EXISTS(SELECT*FROM TOUR WHERE MaTOUR=@MaTOUR)
BEGIN
	-- kiem tra khoa
	IF EXISTS(SELECT*FROM Lich_TOURDL WHERE MaTOUR=@MaTOUR
		AND NgayKH=@NgayKH)
	PRINT N'Đã tồn tại'+ @MaTOUR+' '+@NgayKH+'trong CSDL.'
	ELSE
	BEGIN
	INSERT INTO Lich_TOURDL VALUES(@MaTOUR,@NgayKH,@TenHDV,@SoNguoi,@TenKH)
	PRINT N'Thêm lich_TOURDL thành công.'
	END
END
ELSE
	print N'Vi phạm RBTV khóa ngoại: Không tồn tại mã TOUR '+ @MaTOUR + ' trong CSDL.'
GO 
--- goi lênh nhap thu tuc
set dateformat dmy
EXEC usp_Insert_Lich_TOURDL 'T001','14/02/2017',N'Vân',20,N'Nguyễn Hoàng'
EXEC usp_Insert_Lich_TOURDL 'T002','14/02/2017',N'Nam',30,N'Lê Ngọc'
EXEC usp_Insert_Lich_TOURDL 'T002','06/03/2017',N'Hùng',20,N'Lý Dũng'
EXEC usp_Insert_Lich_TOURDL 'T003','18/02/2017',N'Dũng',20,N'Lý Dũng'
EXEC usp_Insert_Lich_TOURDL 'T004','18/02/2017',N'Hùng',30,N'Dũng Nam'
EXEC usp_Insert_Lich_TOURDL 'T003','10/03/2017',N'Nam',45,N'Nguyễn An'
EXEC usp_Insert_Lich_TOURDL 'T002','28/04/2017',N'Vân',25,N'Ngọc Dung'
EXEC usp_Insert_Lich_TOURDL 'T004','29/04/2017',N'Dũng',35,N'Lê Ngọc'
EXEC usp_Insert_Lich_TOURDL 'T001','30/04/2017',N'Nam',25,N'Trần Nam'
EXEC usp_Insert_Lich_TOURDL 'T003','15/06/2017',N'Vân',20,N'Trịnh Bá'
--- xem bang ----
SELECT*FROM Lich_TOURDL
GO
------ truy van ------
(--a) Cho biết các tour du lịch có tổng số ngày của tour từ 3 đến 5 ngày.
SELECT MaTOUR,TongSoNgay
FROM TOUR
WHERE TOUR.TongSoNgay >=3 AND TOUR.TongSoNgay <=5
GO
--(b)Cho biết thông tin các tour được tổ chức trong tháng 2 năm 2017.
SET DATEFORMAT DMY
SELECT MaTOUR,NgayKH,TenHDV,SoNguoi,TenKH
FROM Lich_TOURDL
WHERE MONTH(NgayKH)= 02 AND YEAR(NgayKH) = 2017
GO
--(c) Cho biết các tour không đi qua thành phố 'Nha Trang'.
SELECT ThanhPho.MaTP,TenTP,MaTOUR,SoNgay
FROM ThanhPho,TOURTP
WHERE ThanhPho.MaTP=TOURTP.MaTP
AND ThanhPho.TenTP NOT LIKE N'Nha Trang'
 GO
--(d) Cho biết số lượng thành phố mà mỗi tour du lịch đi qua.
--????? 
SELECT ThanhPho.MaTP,COUNT(SUM(TOURTP.MaTOUR)) AS TONGSOTPDIQUA,SoNgay,TenTP
FROM TOURTP,ThanhPho
WHERE ThanhPho.MaTP=TOURTP.MaTP
GROUP BY ThanhPho.MaTP,MaTOUR,SoNgay,TenTP
GO
--(e) Cho biết số lượng tour du lịch mỗi hướng dẫn viên hướng dẫn. 
SELECT TenHDV,COUNT(TenHDV)AS SOLUONGTOUR
FROM Lich_TOURDL,TOUR
WHERE Lich_TOURDL.MaTOUR=TOUR.MaTOUR
GROUP BY TenHDV
-- (f) Cho biết tên thành phố có nhiều tour du lịch đi qua nhất.
SELECT TenTP,COUNT(TOURTP.MaTP)AS SOLUONGTP
FROM ThanhPho,TOURTP
WHERE ThanhPho.MaTP=TOURTP.MaTP
GROUP BY TenTP,ThanhPho.MaTP
HAVING COUNT(TOURTP.MaTP) >= ALL(SELECT COUNT(TOURTP.MaTP)
				FROM ThanhPho,TOURTP
				WHERE ThanhPho.MaTP=TOURTP.MaTP
				GROUP BY ThanhPho.MaTP)
GO
-- (g) Cho biết thông tin của tour du lịch đi qua tất cả các thành phố.
SELECT TOURTP.MaTOUR,COUNT(TOURTP.MaTP)AS SOTP
FROM TOURTP,TOUR
WHERE TOURTP.MaTOUR=TOUR.MaTOUR
GROUP BY TOURTP.MaTOUR
HAVING COUNT(TOURTP.MaTP) >= ALL(SELECT COUNT (MaTP)
									FROM ThanhPho)
SELECT*FROM TOURTP
GO
			-----TEST----
--- chen them du lieu text-----
INSERT INTO TOURTP
VALUES ('T004','01',10)
INSERT INTO TOURTP
VALUES ('T004','03',10)
SELECT*FROM TOURTP
GO
--- Trả lại dữ liệu ban đầu---
DELETE FROM TOURTP
WHERE MaTOUR='T004' AND MaTP='01' AND SoNgay=10
DELETE FROM TOURTP
WHERE MaTOUR='T004' AND MaTP='03' AND SoNgay=10
SELECT*FROM TOURTP
GO
--(h) Lập danh sách các tour đi qua thành phố 'Ðà Lạt', 
	--thông tin cần hiển thị bao gồm: Mã tour, Songay.
SELECT TenTP,MaTOUR,SoNgay
FROM ThanhPho,TOURTP
WHERE ThanhPho.MaTP=TOURTP.MaTP AND TenTP LIKE N'Đà Lạt'
GO
-- (i) Cho biết thông tin của tour du lịch có 
--tổng số lượng khách tham gia nhiều nhất.
SELECT Lich_TOURDL.MaTOUR,TongSoNgay,NgayKH,TenHDV,SoNguoi,TenKH
FROM TOUR,Lich_TOURDL
WHERE TOUR.MaTOUR=Lich_TOURDL.MaTOUR
AND SoNguoi >= ALL(SELECT SoNguoi
					FROM Lich_TOURDL)
GO
-- (j) Cho biết tên thành phố mà tất cả các tour du lịch đều đi qua. 
SELECT TenTP,COUNT(MaTOUR) AS SoTOUR
FROM TOURTP,ThanhPho
WHERE TOURTP.MaTP=ThanhPho.MaTP
GROUP BY TenTP
HAVING COUNT(MaTOUR) >= ALL(SELECT COUNT(MaTOUR) 
							FROM TOUR)
SELECT*FROM TOURTP
GO
--- chen them du lieu text-----
INSERT INTO TOURTP
VALUES ('T004','01',10)
SELECT*FROM TOURTP
GO
--- Trả lại dữ liệu ban đầu---
DELETE FROM TOURTP
WHERE MaTOUR='T004' AND MaTP='01' AND SoNgay=10
SELECT*FROM TOURTP
------XONG------