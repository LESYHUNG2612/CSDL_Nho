------------------------------------------------
/* Học phần: Cơ sở dữ liệu
   Ngày: 14/05/2020
   Người thực hiện: LÊ SỸ HÙNG
*/
------------------------------------------------
--lenh tao CSDL
CREATE DATABASE Lab06_QUANLYHOCVIEN
GO
USE Lab06_QUANLYHOCVIEN
GO
CREATE TABLE GiaoVien
(MSGV CHAR(5) PRIMARY KEY,
HoGV NVARCHAR(20) NOT NULL,
TenGV NVARCHAR(10) NOT NULL,
DienThoai CHAR(11)
)
SELECT*FROM GiaoVien
GO
CREATE TABLE CaHoc
(MaCa INT PRIMARY KEY,
GioBD TIME,
GioKT TIME,
)
SELECT*FROM CaHoc
GO
CREATE TABLE LopHoc
( MaLop CHAR(7) PRIMARY KEY,
TenLop CHAR(20) NOT NULL,
NgayKG DATETIME,
HocPhi INT CHECK (HocPhi > 0),
MaCa INT REFERENCES CaHoc(MaCa),
SoTiet INT CHECK (SoTiet >0),
SoHV INT,
MSGV CHAR(5) REFERENCES GiaoVien(MSGV)
)
SELECT*FROM LopHoc
GO
CREATE TABLE HocVien
(MSHV CHAR(7) PRIMARY KEY,
HoHV NVARCHAR(20),
TenHV NVARCHAR(10),
NgaySinh DATETIME,
Phai NVARCHAR(5),
MaLop CHAR(7) REFERENCES LopHoc(MaLop)
)
SELECT*FROM HocVien
GO
CREATE TABLE HocPhi
(SoBL CHAR(4) PRIMARY KEY,
MSHV CHAR(7)REFERENCES HocVien(MSHV),
NgayThu DATETIME,
SoTien INT CHECK (SoTien > 0),
NoiDung CHAR(50),
NguoiThu NVARCHAR(10)
)
SELECT*FROM HocPhi
GO
SELECT*FROM CaHoc
SELECT*FROM GiaoVien
SELECT*FROM LopHoc
SELECT*FROM HocVien
SELECT*FROM HocPhi
GO
		---------------CÁC THỦ TỤC------------

---nhap du lieu cho bang su dung thu tuc-----
CREATE PROC usp_Insert_GiaoVien
@MSGV CHAR(5),@HoGV NVARCHAR(20),@TenGV NVARCHAR(10),@DienThoai CHAR(11)
AS
IF EXISTS(SELECT*FROM GiaoVien WHERE MSGV=@MSGV)
PRINT N'Đã tồn tại MSGV'+@MSGV+'trong CSDL.'
ELSE
	BEGIN
	INSERT INTO GiaoVien VALUES(@MSGV,@HoGV,@TenGV,@DienThoai)
	PRINT N'Thêm Giáo Viên Thành Công'
	END
GO
EXEC usp_Insert_GiaoVien 'G001',N'Lê Hoàng',N'Anh','858936'
EXEC usp_Insert_GiaoVien 'G002',N'Nguyễn Ngọc',N'Lan','845632'
EXEC usp_Insert_GiaoVien 'G003',N'Trần Minh',N'Hùng','823456'
EXEC usp_Insert_GiaoVien 'G004',N'Võ Thanh',N'Trung','841256'
--- xem Bảng Giáo Vên---------
SELECT*FROM GiaoVien
--- thủ tục thêm Ca-----------
GO
CREATE PROC usp_Insert_CaHoc
@MaCa INT,@GioBD TIME,@GioKT TIME
AS
IF  EXISTS(SELECT*FROM CaHoc WHERE MaCa=@MaCa)
PRINT N'Đã tồn tại Ca'+@MaCa+'trong CSDL.'
ELSE 
	BEGIN
	INSERT INTO CaHoc VALUES(@MaCa,@GioBD,@GioKT)
	PRINT N'Thêm Ca Thành Công'
	END
GO
	-----them ca----------
EXEC usp_Insert_CaHoc '1','7:30','10:30'
EXEC usp_Insert_CaHoc '2','13:30','16:30'
EXEC usp_Insert_CaHoc '3','17:30','20:30'
------------------ xem bang --------------
SELECT*FROM CaHoc
----- nhap du lieu thu tuc cho bang lop hoc-----
CREATE PROC usp_Insert_LopHoc
@MaLop CHAR(5),@TenLop CHAR(20),@NgayKG DATETIME,@HocPhi INT,@MaCa INT,
@SoTiet INT,@SoHV INT,@MSGV CHAR(5)
AS
-- kiem tra khoa ngoai
IF EXISTS(SELECT*FROM CaHoc WHERE MaCa=@MaCa)
	AND EXISTS(SELECT*FROM GiaoVien WHERE MSGV=@MSGV)
BEGIN
	IF EXISTS(SELECT*FROM LopHoc WHERE MaLop=@MaLop)
	PRINT N'Đã tồn Tại Lớp '+@MaLop+'Trong CSDL.'
	ELSE
		BEGIN
		INSERT INTO LopHoc VALUES(@MaLop,@TenLop,@NgayKG,@HocPhi,@MaCa,@SoTiet,@SoHV,@MSGV)
		PRINT N'Thêm Lớp Học thành công.'
	END
END
ELSE 
	IF NOT EXISTS(SELECT*FROM GiaoVien WHERE MSGV=@MSGV)
	PRINT N'Không có Giáo Viên'+ @MSGV +'Trong CSDL.'
	ELSE
	PRINT N'Không có Ca'+ @MaCa +'Trong CSDL.'
GO
SET DATEFORMAT DMY
EXEC usp_Insert_LopHoc 'E114','Excel 3-5-7','02/01/2008','120000','1','45','3','G003'
EXEC usp_Insert_LopHoc'E115','Excel 2-4-6','22/01/2008','120000','3','45','0','G001'
EXEC usp_Insert_LopHoc 'W123','Word 2-4-6','18/02/2008','100000','3','30','1','G001'
EXEC usp_Insert_LopHoc'W124','Word 3-5-7','01/03/2008','100000','1','30','0','G002'
EXEC usp_Insert_LopHoc'A075','Excel 2-4-6','18/12/2008','150000','3','60','3','G003'
SELECT*FROM LopHoc 
GO
--------- thủ tục thêm học viên ---------------
CREATE PROC usp_Insert_HocVien
@MSHV CHAR(7),@HoHV NVARCHAR(20),@TenHV NVARCHAR(10),@NgaySinh DATETIME,
@Phai NVARCHAR(5),@MaLop CHAR(5)
AS
-- kiem tra khoa ngoai
IF EXISTS(SELECT*FROM LopHoc WHERE MaLop=@MaLop)
BEGIN
	IF EXISTS(SELECT*FROM HocVien WHERE MSHV=@MSHV)
	PRINT N'Đã tồn Tại Học Viên '+@MSHV+'Trong CSDL.'
	ELSE
	BEGIN
		INSERT INTO HocVien VALUES(@MSHV,@HoHV,@TenHV,@NgaySinh,@Phai,@MaLop)
		PRINT N'Thêm Lớp Học thành công.'
	END
END
ELSE 
	IF NOT EXISTS(SELECT*FROM LopHoc WHERE MaLop=@MaLop)
	PRINT N'không có Lớp Học'+ @MaLop +'TRong CSDL.'
GO
	-----them Hoc vien----------
EXEC usp_Insert_HocVien 'A07501',N'Lê Văn',N'Minh','10/06/1998',N'Nam','A075'
EXEC usp_Insert_HocVien 'A07502',N'Nguyễn Thị',N'Mai','20/04/1998',N'Nữ','A075'
EXEC usp_Insert_HocVien 'A07503',N'Lê Ngọc',N'Tuấn','10/06/1994',N'Nam','A075'
EXEC usp_Insert_HocVien 'E11401',N'Vương Tuấn',N'Vũ','25/03/1999',N'Nam','E114'
EXEC usp_Insert_HocVien 'E11402',N'Lý Ngọc',N'Hân','01/12/1995',N'Nữ','E114'
EXEC usp_Insert_HocVien 'E11403',N'Trần Mai',N'Linh','04/06/1990',N'Nữ','E114'
EXEC usp_Insert_HocVien 'W12301',N'Nguyễn Ngọc',N'Tuyết','12/05/1996',N'Nữ','W123'
------------------ xem bang --------------
SELECT*FROM HocVien
-- thu tuc nhap ham hoc phi
CREATE PROC usp_Insert_HocPhi
@SoBL CHAR(4),@MSHV CHAR(7),@NgayThu DATETIME,@SoTien INT,@NoiDung CHAR(50),@NguoiThu NVARCHAR(10)
AS
-- kiem tra khoa ngoai
IF EXISTS(SELECT*FROM HocVien WHERE MSHV=@MSHV)
BEGIN
	IF EXISTS(SELECT*FROM HocPhi WHERE SoBL=@SoBL)
	PRINT N'Đã tồn Tại biên lai học phí '+@SoBL+'Trong CSDL.'
	ELSE
	BEGIN
		INSERT INTO HocPhi VALUES(@SoBL,@MSHV,@NgayThu,@SoTien,@NoiDung,@NguoiThu)
		PRINT N'Thêm Biên lai Học Phí thành công.'
	END
END
ELSE 
	IF NOT EXISTS(SELECT*FROM HọcVien WHERE MSHV=@MSHV)
	PRINT N'không có Học Viên'+ @MSHV +'TRong CSDL.'
GO
---- thêm hoc viên-----
SET DATEFORMAT DMY
EXEC usp_Insert_HocPhi '0001','E11401','02/01/2008','120000','HP Excel 3-5-7',N'Vân'
EXEC usp_Insert_HocPhi '0002','E11402','02/01/2008','120000','HP Excel 3-5-7',N'Vân'
EXEC usp_Insert_HocPhi '0003','E11403','02/01/2008','80000','HP Excel 3-5-7',N'Vân'
EXEC usp_Insert_HocPhi '0004','W12301','18/02/2008','100000','HP Word 2-4-6,',N'Lan'
EXEC usp_Insert_HocPhi '0005','A07501','16/12/2008','150000','HP Access 2-4-6',N'Lan'
EXEC usp_Insert_HocPhi '0006','A07502','16/12/2008','100000','HP Access 2-4-6',N'Lan'
EXEC usp_Insert_HocPhi '0007','A07503','18/12/2008','150000','HP Access 2-4-6',N'Vân'
EXEC usp_Insert_HocPhi '0008','A07502','15/01/2009','50000','HP Access 2-4-6',N'Vân'
SELECT*FROM HocPhi
----------CÀI ĐẶT RÀNG BUỘC TOÀN VẸN------------
	    ------SỬ DỤNG TRIGER--------
	----- ràng buộc giờ trong ca------
CREATE TRIGGER trg_GioBT_GioKT 
ON CaHoc FOR INSERT,UPDATE
AS 
IF UPDATE(GioBD) OR UPDATE(GioKT)
IF EXISTS (SELECT*FROM Inserted i WHERE i.GioBD>=i.GioKT)
BEGIN
RAISERROR (N'Giờ kết thúc ca hoc không thể nhỏ hơn giờ bắt ',15,1)
ROLLBACK TRAN 
END
GO
INSERT INTO CaHoc VALUES (4,'16:00','10:00')
UPDATE CaHoc SET GioKT='06:00' WHERE MaCa = 1
SELECT*FROM CaHoc
	--------Ràng buộc sĩ Số của 1 lớp--------
----CREATE TRIGGER trg_Sisolophoc
----ON LopHoc FOR INSERT,UPDATE
----AS 
----IF UPDATE(SoHV) 
----IF EXISTS(SELECT*FROM Inserted Lop WHERE Lop.SoHV <= 30 AND Lop.SoHV =  