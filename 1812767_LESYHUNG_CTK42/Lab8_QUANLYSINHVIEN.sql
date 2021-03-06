------------------------------------------------
/* Học phần: Cơ sở dữ liệu
   Ngày: 18/05/2020
   Người thực hiện: LÊ SỸ HÙNG
*/
------------------------------------------------
--lenh tao CSDL
CREATE DATABASE Lab8_QUANLYSINHVIEN
---- su dung 
USE Lab8_QUANLYSINHVIEN
----- create table----
CREATE TABLE Khoa
( MSKhoa CHAR(2) PRIMARY KEY,
TenKhoa NVARCHAR(30),
TenTat CHAR(4)
)
SELECT*FROM Khoa
GO
---- create lop----
CREATE TABLE Lop
(MSLop CHAR(4) PRIMARY KEY,
TenLop NVARCHAR(30),
MSkhoa CHAR(2) REFERENCES Khoa(MSKhoa),
NienKhoa CHAR(4)
)
SELECT*FROM Lop
--- create tinh---
CREATE TABLE Tinh
(MSTinh CHAR(2) PRIMARY KEY,
TenTinh NVARCHAR(20)
)
SELECT*FROM Tinh
---- create sinh vien---
CREATE TABLE SinhVien
(MSSV CHAR(7) PRIMARY KEY,
Ho NVARCHAR(20) NOT NULL,
Ten NVARCHAR(10) NOT NULL,
Ngaysinh DATETIME,
MSTinh CHAR(2) REFERENCES Tinh(MSTinh),
NgayNhapHoc DATETIME,
MSLop CHAR(4) REFERENCES Lop(MSLop),
Phai CHAR(3),
DiaChi NVARCHAR(50),
DienThoai CHAR(10)
)
SELECT*FROM Tinh
----- create Mon hoc---
CREATE TABLE MonHoc
(MSMH CHAR(4)PRIMARY KEY,
TenMH NVARCHAR(40),
HeSo CHAR(1)
)
SELECT*FROM MonHoc
GO
----  Diem----
CREATE TABLE BangDiem
(MSSV CHAR(7)REFERENCES SinhVien(MSSV),
MSMH CHAR(4) REFERENCES MonHoc(MSMH),
LanThi INT,
Diem FLOAT,
PRIMARY KEY (MSSV,MSMH,LanThi)
)
SELECT*FROM BangDiem
GO
---- thu tuc nhap -----
CREATE PROC usp_Insert_Khoa
@MSKhoa CHAR(2),@TenKhoa NVARCHAR(30),@TenTat CHAR(4)
AS
IF EXISTS(SELECT*FROM Khoa WHERE MSKhoa=@MSKhoa)
PRINT N'Khoa tồn tại '+@MSKhoa +'Trong CSDL. '
BEGIN
	INSERT INTO Khoa VALUES(@MSKhoa,@TenKhoa,@TenTat)
	PRINT N'Thêm khoa Thành công.'
END
GO
---- goi ham thu tuc---
EXEC usp_Insert_Khoa '01',N'Công Nghệ Thông Tin','CNTT'
EXEC usp_Insert_Khoa '02', N'Điện Tử Viễn Thông','DTVT'
EXEC usp_Insert_Khoa '03', N'Quản Trị Kinh Doanh','QTKD'
EXEC usp_Insert_Khoa '04',N'Công Nghệ Sinh Học','CNSH'
SELECT*FROM Khoa
GO
----- ham thu tuc lop----
CREATE PROC usp_Insert_Lop1
@MSLop CHAR(4),@TenLop NVARCHAR(30),@MSkhoa CHAR(2),@NienKhoa CHAR(4)
AS

IF EXISTS(SELECT*FROM Khoa WHERE MSKhoa=@MSKhoa)
	BEGIN 
		IF EXISTS(SELECT*FROM Lop WHERE MSLop=@MSLop)
		PRINT N'Đã tồn tại '+ @MSLop+'Trong CSDL.'
	ELSE 
	BEGIN
		INSERT INTO Lop VALUES (@MSlop,@TenLop,@MSkhoa,@NienKhoa)
		PRINT N'Thêm lớp thành công.'
	END
END
ELSE
	 IF NOT EXISTS(SELECT*FROM Lop WHERE MSKhoa=@MSKhoa)
	PRINT N'không tôn tại khoa'+ @MSkhoa +'Trong CSDL.'
GO
----- nhap -----
EXEC usp_Insert_Lop1 '98TH',N'Tin Học Khoa 1998','01','1998'
EXEC usp_Insert_Lop1 '98VT',N'Viễn Thông khoa 1998','02','1998'
EXEC usp_Insert_Lop1 '99TH',N'Tin Hoc Khoa 1999','01','1999'
EXEC usp_Insert_Lop1 '99VT',N'Viễn Thông Khoa 1999','02','1999'
EXEC usp_Insert_Lop1 '99QT',N'Quản Trị Khoa 1999','03','1999'
SELECT*FROM Lop
GO
------ Thu Tuc Nhap Tinh----
CREATE PROC usp_Insert_Tinh
@MSTinh CHAR(2),@TenTinh NVARCHAR(20)
AS
IF EXISTS(SELECT*FROM Tinh WHERE MSTinh=@MSTinh)
PRINT N'Tỉnh tồn tại '+@MSTinh +'Trong CSDL. '
BEGIN
	INSERT INTO Tinh VALUES(@MSTinh,@TenTinh)
	PRINT N'Thêm khoa Thành công.'
END
GO
EXEC usp_Insert_Tinh '01',N'An Giang'
EXEC usp_Insert_Tinh '02',N'TPHCM'
EXEC usp_Insert_Tinh '03',N'Đồng Nai' 
EXEC usp_Insert_Tinh '04',N'Long An'
EXEC usp_Insert_Tinh '05',N'Huế'
EXEC usp_Insert_Tinh '06',N'Cà Mau'
SELECT*FROM Tinh
GO
---- thu tuc them sinh viên----
CREATE PROC usp_Insert_SinhVien
@MSSV CHAR(7),@Ho NVARCHAR(20),@Ten NVARCHAR(10),@Ngaysinh DATETIME,
@MSTinh CHAR(2),@NgayNhapHoc DATETIME,@MSLop CHAR(4),@Phai CHAR(3),
@DiaChi NVARCHAR(50),@DienThoai CHAR(10)
AS
IF EXISTS(SELECT*FROM lop WHERE MSLop=@MSLop)
	AND  EXISTS(SELECT*FROM Tinh WHERE MSTinh=@MSTinh)
	BEGIN
	IF EXISTS(SELECT*FROM SinhVien WHERE MSSV=@MSSV)
	PRINT N'Sinh Viên'+@MSSV+'Trong CSDL.'
	ELSE
	BEGIN
	INSERT INTO SinhVien VALUES (@MSSV,@Ho,@Ten,@Ngaysinh,@MSTinh,@NgayNhapHoc,@MSLop,@Phai,@DiaChi,@DienThoai)
	PRINT N'Thêm sinh viên Thành công.'
	END
END
ELSE
 IF NOT EXISTS(SELECT*FROM lop WHERE MSLop=@MSLop)
 PRINT N'Không Tồn Tại'+ @MSLop+'Trong CSDL.'
 ELSE
 PRINT N'Không Tồn Tại'+ @MSTinh+'Trong CSDL.'
GO
----nhap du liêu----
SET DATEFORMAT DMY
EXEC usp_Insert_SinhVien '98TH001',N'Nguyễn Văn',N'An','06/08/80','01','03/09/98','98TH','Yes',N'12 Trần Hưng Đạo Q.1','8234512'
EXEC usp_Insert_SinhVien '98TH002',N'Lê Thi',N'An','17/10/79','01','03/09/98','98TH','No',N'23 CMT8 Q.Tân Bình','0303234342'
EXEC usp_Insert_SinhVien '98VT001',N'Nguyễn Đức',N'Bình','25/11/81','02','03/09/98','98VT','Yes',N'245 Lạc Long Quân Q.11','8654323'  
EXEC usp_Insert_SinhVien '98VT002',N'Trần Ngọc',N'Anh','19/08/80','02','03/09/98','98VT','No',N'242 Trần Hưng Đạo Q.1','-'
EXEC usp_Insert_SinhVien '99TH001',N'Lý Văn Hùng',N'Dũng','27/09/81','03','05/10/99','99TH','Yes',N'178 CMT8 Q. Tân Bình','756321'
EXEC usp_Insert_SinhVien '99TH002',N'Văn Minh',N'Hoàng','01/01/81','04','05/10/99','99TH','Yes',N'272 Lý Thường Kiệt Q.10','8341234 '
EXEC usp_Insert_SinhVien '99TH003',N'Nguyễn',N'Tuấn','12/01/80','03','05/10/99','99TH','Yes',N'162 Trần Hưng Đạo Q.5','-'
EXEC usp_Insert_SinhVien '99TH004',N'Trần Văn',N'Minh','25/06/81','04','05/10/99','99TH','Yes',N'147 Điện Biên Phủ, Q.3','7236754 '
EXEC usp_Insert_SinhVien '99TH005',N'Nguyễn Thái',N'Minh','01/01/80 ','04','05/10/99 ','99TH','Yes',N'345 Lê Đại Hành Q.11','-'
EXEC usp_Insert_SinhVien '99VT001',N'Lê Ngọc',N'Mai','21/06/82','01','05/10/99','99VT','No',N'129 Trần Hưng Đạo Q.1','0903124534'
EXEC usp_Insert_SinhVien '99QT001',N'Nguyễn Thi',N'Oanh','19/08/73','04','05/10/99','99QT','No',N'76 Hùng Vương Q.5','0901656324'
EXEC usp_Insert_SinhVien '99QT002',N'Lê My',N'Hạnh','20/05/76','04','05/10/99','99QT','No',N'12 Phạm Ngọc Thạch Q.3','-'
SELECT*FROM SinhVien
GO
---- thu tuc mon hoc=-------
CREATE PROC usp_Insert_MonHoc
@MSMH CHAR(4),@TenMH NVARCHAR(40),@HeSo CHAR(1)
AS
IF EXISTS(SELECT*FROM MonHoc WHERE MSMH=@MSMH)
PRINT N'Môn Học tồn tại '+@MSMH +'Trong CSDL. '
BEGIN
	INSERT INTO MonHoc VALUES(@MSMH,@TenMH,@HeSo)
	PRINT N'Thêm Môn Học Thành công.'
END
GO
EXEC usp_Insert_MonHoc 'TA01',N'Nhập Môn Tin Học','2'
EXEC usp_Insert_MonHoc 'TA02',N'Lập Trình Cơ Bản','3'
EXEC usp_Insert_MonHoc 'TB01',N'Cấu Trúc Dữ Liệu','2'
EXEC usp_Insert_MonHoc 'TB02',N'Cơ Sỡ Dữ Liệu','2'
EXEC usp_Insert_MonHoc 'QA01',N'Kinh Tế Vĩ Mô','2'
EXEC usp_Insert_MonHoc 'QA02',N'Quản Trị Chất Lượng','3'
EXEC usp_Insert_MonHoc 'VA01',N'Điện Tử Cơ Bản','2'
EXEC usp_Insert_MonHoc 'VA02',N'Mạch Số','3'
EXEC usp_Insert_MonHoc 'VB01',N'Truyền Số Dữ liệu','3'
EXEC usp_Insert_MonHoc 'XA01',N'Vật Lý Đại Cương','2'
SELECT*FROM MonHoc
GO
---- thu tuc bang diem=----
CREATE PROC usp_Insert_BangDiem
@MSSV CHAR(7),@MSMH CHAR(4),@LanThi INT,@Diem FLOAT
AS
IF EXISTS(SELECT*FROM SinhVien WHERE MSSV= @MSSV)
	AND  EXISTS(SELECT*FROM MonHoc WHERE MSMH=@MSMH)
	AND EXISTS(SELECT*FROM BangDiem WHERE LanThi=@LanThi)
	PRINT N'Tồn Tại Điểm Trong CSDL.'
ELSE
	 IF NOT EXISTS(SELECT*FROM SinhVien WHERE MSSV=@MSSV)
		PRINT N'Không Tồn Tại Sinh Viên'+ @MSSV+'Trong CSDL.'
	IF NOT EXISTS(SELECT*FROM MonHoc WHERE MSMH=@MSMH)
		PRINT N'Không Tồn Tại Môn Học'+ @MSMH+'Trong CSDL.'
	ELSE
	BEGIN
	INSERT INTO BangDiem VALUES (@MSSV,@MSMH,@LanThi,@Diem)
	PRINT N'Thêm Điểm Thành công.'
	END
GO
EXEC usp_Insert_BangDiem '98TH001','TA01','1','8.5'
EXEC usp_Insert_BangDiem '98TH001','TA02','1','8.0'
EXEC usp_Insert_BangDiem '98TH002','TA01','1','4'
EXEC usp_Insert_BangDiem '98TH002','TA01','2','5.5'
EXEC usp_Insert_BangDiem '98TH001','TB01','1','7.5'
EXEC usp_Insert_BangDiem '98TH002','TB01','1','8'
EXEC usp_Insert_BangDiem '98VT001','VA01','1','4'
EXEC usp_Insert_BangDiem '98VT001','VA01','2','5'
EXEC usp_Insert_BangDiem '98VT002','VA02','1','7.5'
EXEC usp_Insert_BangDiem '99TH001','TA01','1','4'
EXEC usp_Insert_BangDiem '99TH001','TA01','2','6'
EXEC usp_Insert_BangDiem '99TH001','TB01','1','6.5'
EXEC usp_Insert_BangDiem '99TH002','TB01','1','10'
EXEC usp_Insert_BangDiem '99TH002','TB02','1','9'
EXEC usp_Insert_BangDiem '99TH003','TA02','1','7.5'
EXEC usp_Insert_BangDiem '99TH003','TB01','1','3'
EXEC usp_Insert_BangDiem '99TH003','TB01','2','6'
EXEC usp_Insert_BangDiem '99TH003','TB02','1','8'
EXEC usp_Insert_BangDiem '99TH004','TB02','1','2'
EXEC usp_Insert_BangDiem '99TH004','TB02','2','4'
EXEC usp_Insert_BangDiem '99TH004','TB02','3','3'
EXEC usp_Insert_BangDiem '99QT001','QA01','1','7'
EXEC usp_Insert_BangDiem '99QT001','QA02','1','6.5'
EXEC usp_Insert_BangDiem '99QT002','QA01','1','8.5'
EXEC usp_Insert_BangDiem '99QT002','QA02','1','9'
SELECT*FROM BangDiem

------ Truy Van Du lieu-----
--1) Liệt kê MSSV, Họ, Tên, Địa chỉ của tất cả các sinh viên 
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi
FROM SinhVien
--2) Liệt kê MSSV, Họ, Tên, MS Tỉnh của tất cả các sinh viên. Sắp xếp kết quả
-- theo MS tỉnh, trong cùng tỉnh sắp xếp theo họ tên  của sinh viên.
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh
FROM SinhVien
ORDER BY MSTinh ,Ho,Ten,DiaChi,MSSV
--3) Liệt kê các sinh viên nữ của tỉnh Long An 
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh
FROM SinhVien
WHERE Phai LIKE N'Nữ'
AND MSTinh LIKE '04'
--4) Liệt kê các sinh viên có sinh nhật trong tháng giêng.
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh,Ngaysinh
FROM SinhVien
WHERE MONTH(Ngaysinh)='01'
--5) Liệt kê các sinh viên có sinh nhật nhằm ngày 1/1. 
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh,Ngaysinh
FROM SinhVien
WHERE MONTH(Ngaysinh)='01'
AND DAY(Ngaysinh)='01'
--6) Liệt kê các sinh viên có số điện thoại.
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh,Ngaysinh,DienThoai
FROM SinhVien
WHERE DienThoai NOT LIKE '-'
--7) Liệt kê các sinh viên có số điện thoại di động.
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh,Ngaysinh,DienThoai
FROM SinhVien
WHERE LEN(DienThoai)=10
--8) Liệt kê các sinh viên tên ‘Minh’ học lớp ’99TH’ 
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh,Ngaysinh,DienThoai
FROM SinhVien
WHERE Ten LIKE N'Minh'
AND MSSV LIKE '99TH%'
---9) Liệt kê các sinh viên có địa chỉ ở đường ‘Tran Hung Dao’
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh,Ngaysinh,DienThoai
FROM SinhVien
WHERE DiaChi LIKE N'% Trần Hưng Đạo%'
--10) Liệt kê các sinh viên có tên lót chữ ‘Van’ (không liệt kê người họ ‘Van’)
SELECT MSSV,Ho+' '+Ten AS HoVaTen, DiaChi,MSTinh,Ngaysinh,DienThoai
FROM SinhVien
WHERE Ho LIKE N'%Văn'
AND Ho NOT LIKE N'Văn%'
--11) Liệt kê MSSV, Họ Ten (ghép họ và tên thành một cột), 
--Tuổi của các sinh viên ở tỉnh Long An
SELECT MSSV,Ho+' '+Ten AS HoVaTen,YEAR(GETDATE()) - YEAR(ngaySinh) AS Tuoi,TenTinh
FROM SinhVien
JOIN Tinh ON SinhVien.MSTinh = Tinh.MSTinh
WHERE Tinh.TenTinh = 'Long An';
----12) Liệt kê các sinh viên nam từ 23 đến 28 tuổi. 
SELECT MSSV,Ho+' '+Ten AS HoVaTen,YEAR(GETDATE()) - YEAR(ngaySinh) AS Tuoi
FROM SinhVien
WHERE Phai LIKE N'Nam'
AND(YEAR(GETDATE()) - YEAR(ngaySinh)) >= 23
AND (YEAR(GETDATE()) - YEAR(ngaySinh)) <= 28
----13) Liệt kê các sinh viên nam từ 32 tuổi trở lên và các sinh viên nữ từ 27 tuổi trở lên.
SELECT MSSV,Ho+' '+Ten AS HoVaTen,YEAR(GETDATE()) - YEAR(ngaySinh) AS Tuoi
FROM SinhVien
WHERE Phai LIKE N'Nam'
AND(YEAR(GETDATE()) - YEAR(ngaySinh)) >= 32
OR Phai LIKE N'Nữ'
AND(YEAR(GETDATE()) - YEAR(ngaySinh)) >= 27
----14) Liệt kê các sinh viên khi nhập học còn dưới 18 tuổi, hoặc đã trên 25 tuổi.
SELECT MSSV,Ho+' '+Ten AS HoVaTen,(YEAR(NgayNhapHoc) - YEAR(ngaySinh)) AS Tuoilucnhaphoc
FROM SinhVien
WHERE (YEAR(NgayNhapHoc) - YEAR(ngaySinh))<=18
OR (YEAR(NgayNhapHoc) - YEAR(ngaySinh)) >= 25
----15) Liệt kê danh sách các sinh viên của khóa 99 (MSSV có 2 ký tự đầu là ‘99’).
SELECT MSSV,Ho+' '+Ten AS HoVaTen
FROM SinhVien
WHERE MSSV LIKE '99%'
----16) Liệt kê MSSV, Điểm thi lần 1 môn ‘Co so du lieu’ của lớp ’99TH’
SELECT SinhVien.MSSV,Ho+' '+Ten AS HoVaTen,TenMH,Lanthi
FROM SinhVien,MonHoc,BangDiem
WHERE Sinhvien.MSSV=BangDiem.MSSV AND BangDiem.MSMH=MonHoc.MSMH
AND MSLop LIKE '99TH%'
AND TenMH LIKE N'Cơ Sỡ Dữ Liệu'
----17) Liệt kê MSSV, Họ tên của các sinh viên lớp ’99TH’ thi không đạt lần 1 môn ‘Co so du lieu’
SELECT SinhVien.MSSV,Ho+' '+Ten AS HoVaTen,TenMH,Lanthi,Diem
FROM SinhVien,MonHoc,BangDiem
WHERE Sinhvien.MSSV=BangDiem.MSSV AND BangDiem.MSMH=MonHoc.MSMH
AND MSLop LIKE '99TH%'
AND LanThi LIKE '1'
AND Diem < 4
---- 18) Liệt kê tất cả các điểm thi của sinh viên có mã số ’99TH001’ theo mẫu sau:
SELECT BangDiem.MSMH,TenMH,LanThi,Diem
FROM MonHoc,BangDiem
WHERE MonHoc.MSMH=BangDiem.MSMH
AND BangDiem.MSSV LIKE '99TH001'
--19) Liệt kê MSSV, họ tên, MSLop của các sinh viên có điểm 
--thi lần 1 môn ‘Co so du lieu’ từ 8 điểm trở lên
SELECT SinhVien.MSSV,Ho+' '+Ten AS HoVaTen,LanThi,Diem
FROM BangDiem,SinhVien
WHERE BangDiem.MSSV=SinhVien.MSSV
AND LanThi LIKE '1'
AND Diem >='8'
--20) Liệt kê các tỉnh không có sinh viên theo học 
SELECT *
FROM Tinh
WHERE MSTinh NOT IN(SELECT MSTinh
					FROM SinhVien)
--21) Liệt kê các sinh viên hiện chưa có điểm môn thi nào
SELECT *
FROM SinhVien
WHERE MSSV NOT IN
    (SELECT BangDiem.MSSV
     FROM BangDiem);
--Truy vấn gom nhóm ----
--22) Thống kê số lượng sinh viên ở mỗi lớp theo mẫu sau: MSLop, TenLop, SoLuongSV
SELECT SinhVien.MSLop,TenLop,COUNT(SinhVien.MSLop) AS SoLuongSV
FROM Lop,SinhVien
WHERE Lop.MSLop=SinhVien.MSLop
GROUP BY SinhVien.MSLop,TenLop
ORDER BY SoLuongSV
-- 23) Thống kê số lượng sinh viên ở mỗi tỉnh theo mẫu sau: 
SELECT*FROM SinhVien
SELECT Tinh.MSTinh,TenTinh,
	COUNT(CASE Phai
	WHEN N'Yes' THEN 1
	ELSE NULL
	END)AS N'SoSVNAM',
	COUNT(CASE Phai
	WHEN N'No' THEN 1
	ELSE NULL
	END)AS N'SoSVNỮ',
	COUNT(*) AS N'Tổng SV'
FROM SinhVien
JOIN Tinh ON SinhVien.MSTinh=Tinh.MSTinh
GROUP BY Tinh.MSTinh,TenTinh	
---24) Thống kê kết quả thi lần 1 môn ‘Co so du lieu’ ở các lớp, theo mẫu sau
SELECT
    lop.MSLop AS 'MaLop',
    lop.TenLop AS 'TenLop',
    COUNT(CASE
        WHEN Diem >= 4 THEN 1
        ELSE NULL
    END) AS N'Số SV đạt',
    (COUNT(CASE
        WHEN Diem >= 4 THEN 1
        ELSE NULL
    END) * 100 / COUNT(*)) AS N'Tỉ lệ đạt (%)',
    COUNT(CASE
        WHEN Diem < 4 THEN 1
        ELSE NULL
    END) AS N'Số SV không đạt',
    (COUNT(CASE
        WHEN Diem < 4 THEN 1
        ELSE NULL
    END) * 100 / COUNT(*)) AS N'Tỉ lệ không đạt (%)',
    COUNT(*) AS TongSo
FROM BangDiem
JOIN MonHoc
    ON bangdiem.MSMH = monhoc.MSMH
JOIN sinhvien
    ON sinhvien.MSSV = bangdiem.MSSV
JOIN lop
    ON sinhvien.MSLop = lop.MSLop
WHERE lanthi = 1
AND MonHoc.TenMH = N'Cơ Sỡ Dữ Liệu'
GROUP BY lop.MSLop,
         lop.TenLop
--25Lọc ra điểm cao nhất trong các lần thi cho các sinh viên theo mẫu sau
--26) Lập bảng tổng kết theo mẫu sau
--Tổng (điểm x hệ số)/Tổng hệ số 
SELECT SinhVien.MSSV,Ho,Ten,SUM(Diem*HeSo)/HeSo AS ĐTB
FROM SinhVien,BangDiem,MonHoc
WHERE SinhVien.MSSV=BangDiem.MSSV AND MonHoc.MSMH=BangDiem.MSMH
GROUP BY SinhVien.MSSV,Ho,Ten,Diem,HeSo

--27) Thống kê số lượng sinh viên tỉnh ‘Long An’ đang theo học ở các khoa, theo mẫu sau
SELECT YEAR(NienKhoa) AS N'Năm Học',Khoa.MSkhoa,TenKhoa,COUNT(Khoa.MSKhoa)AS SoSV
FROM SinhVien,Tinh,Lop,Khoa
WHERE SinhVien.MSLop=Lop.MSLop
AND Lop.MSkhoa=Khoa.MSKhoa
AND SinhVien.MSTinh=Tinh.MSTinh
GROUP BY NienKhoa,Khoa.MSKhoa,Khoa.TenKhoa
Go
			--======Hàm & Thủ tục=====--
--28) Nhập vào MSSV, in ra bảng điểm của sinh viên đó theo mẫu sau 
--(điểm in ra lấy điểm cao nhất trong các lần thi):  
create proc usp_InDanhMuc_Diemsinhvien2
@MSSV CHAR(7)
AS
	SELECT MSSV,BangDiem.MSMH,TenMH,HeSo,Diem,LanThi
	FROM BangDiem,MonHoc
	Where	BangDiem.MSMH=MonHoc.MSMH
	AND MSSV= @MSSV
go
----- text
exec usp_InDanhMuc_Diemsinhvien2 '98TH001'
GO
--29) Nhập vào MS lớp, in ra bảng tổng kết của lớp đó, theo mẫu sau: 
create proc usp_InDanhMuc_BangTongKet4
@MSLop CHAR(4)
AS
	SELECT SinhVien.MSSV,Ho,Ten,SUM(Diem*HeSo)/HeSo AS ĐTB,
	    (CASE
        WHEN SUM(Diem*HeSo)/HeSo < 4 THEN 1
        ELSE NULL
    END) AS Yếu,
     CASE
        WHEN SUM(Diem*HeSo)/HeSo >= 4 AND SUM(Diem*HeSo)/HeSo <=6.5 THEN 1
        ELSE NULL
    END AS TrungBinh,
      CASE
        WHEN SUM(Diem*HeSo)/HeSo >= 6.5 AND SUM(Diem*HeSo)/HeSo < 8 THEN 1
        ELSE NULL
    END AS Khá,
    CASE
        WHEN SUM(Diem*HeSo)/HeSo >= 8 AND SUM(Diem*HeSo)/HeSo <= 10 THEN 1
        ELSE NULL
    END AS Giỏi
	FROM SinhVien,BangDiem,MonHoc
	Where	SinhVien.MSSV=BangDiem.MSSV AND BangDiem.MSMH=MonHoc.MSMH
	AND MSLop= @MSLop
	GROUP BY SinhVien.MSSV,Ho,Ten,Diem,HeSo
GO
----text---
exec usp_InDanhMuc_BangTongKet4 '98TH'
	----========Cập nhật dữ liệu =========------
	