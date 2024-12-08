-- Drop database if it already exists
DROP DATABASE IF EXISTS hcmut_ssps;

-- Create and use the database
CREATE DATABASE hcmut_ssps
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE hcmut_ssps;

-- CREATE TABLES
-- Customer table
CREATE TABLE customer (
  customer_id INT,
  name VARCHAR(32) NOT NULL,
  password VARCHAR(128) NOT NULL,
  type ENUM('student','lecturer') NOT NULL DEFAULT 'student',
  email VARCHAR(32) NOT NULL,
  balance INT NOT NULL DEFAULT 0,
  last_used DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (customer_id)
) ENGINE=InnoDB;

-- SPSO table
CREATE TABLE spso (
  spso_id INT AUTO_INCREMENT,
  name VARCHAR(32) NOT NULL,
  username VARCHAR(32) NOT NULL,
  password VARCHAR(128) NOT NULL,
  dob DATE NOT NULL DEFAULT (CURRENT_DATE()),
  email VARCHAR(32) NOT NULL,
  phone VARCHAR(16) NOT NULL,
  last_used DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (spso_id),
  CONSTRAINT spso_username_unique UNIQUE (username)
) ENGINE=InnoDB;

-- Printer table
CREATE TABLE printer (
  printer_id INT AUTO_INCREMENT,
  name VARCHAR(256) NOT NULL,
  brand VARCHAR(256) NOT NULL,
  model VARCHAR(256) NOT NULL,
  description VARCHAR(4096) NOT NULL,
  loc_campus ENUM('1','2') NOT NULL DEFAULT '1',
  loc_building VARCHAR(64) NOT NULL,
  loc_room VARCHAR(64) NOT NULL,
  status ENUM('running','disabled','deleted') NOT NULL DEFAULT 'running',
  PRIMARY KEY (printer_id),
  CONSTRAINT printer_name_unique UNIQUE (name)
) ENGINE=InnoDB;

-- Document table
CREATE TABLE document (
  document_id INT AUTO_INCREMENT,
  name VARCHAR(64) NOT NULL,
  file_type VARCHAR(8) NOT NULL,
  no_of_pages INT NOT NULL,
  user_id INT,
  printer_id INT,
  PRIMARY KEY (document_id),
  CONSTRAINT fk_prter_print_doc FOREIGN KEY (printer_id) REFERENCES printer(printer_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_user_own_doc FOREIGN KEY (user_id) REFERENCES customer(customer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Print Order table
CREATE TABLE print_order (
  print_id INT AUTO_INCREMENT,
  side ENUM('1','2') NOT NULL DEFAULT '1',
  page_size ENUM('A4','A3') NOT NULL DEFAULT 'A4',
  orientation ENUM('portrait','landscape') NOT NULL DEFAULT 'portrait',
  pages_per_sheet INT NOT NULL DEFAULT 1,
  scale DECIMAL(3,2) NOT NULL DEFAULT 1.00,
  time_start DATETIME DEFAULT CURRENT_TIMESTAMP(),
  time_end DATETIME DEFAULT CURRENT_TIMESTAMP(),
  status ENUM('success','progress','failed','pending') NOT NULL DEFAULT 'pending',
  pages_to_be_printed VARCHAR(64) DEFAULT NULL,
  num_pages_printed INT DEFAULT NULL,
  document_id INT,
  user_id INT,
  PRIMARY KEY (print_id),
  CONSTRAINT fk_doc_printed FOREIGN KEY (document_id) REFERENCES document(document_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_user_print FOREIGN KEY (user_id) REFERENCES customer(customer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Purchase Order table
CREATE TABLE purchase_order (
  purchase_id INT AUTO_INCREMENT,
  time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  amount INT NOT NULL DEFAULT 0,
  price FLOAT NOT NULL DEFAULT 0,
  status ENUM('unpaid','paid') NOT NULL DEFAULT 'unpaid',
  user_id INT,
  PRIMARY KEY (purchase_id),
  CONSTRAINT fk_user_prchse FOREIGN KEY (user_id) REFERENCES customer(customer_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- INSERT DATA INTO TABLES
-- Insert data for the customer table
INSERT INTO customer (customer_id, name, password, type, email, balance, last_used)
VALUES
(2213768, 'Hồ Ngọc Anh Tuấn', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', 'student', 'tuan.hona2004@hcmut.edu.vn', 100, '2024-11-22 17:55:00'),
(2213707, 'Nông Văn Trung', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', 'student', 'van.trung@hcmut.edu.vn', 100, '2024-11-29 14:19:03'),
(2252868, 'Lê Minh Tuấn', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', 'student', 'tuan.le@hcmut.edu.vn', 100, '2024-10-29 14:17:15'),
(2252542, 'Huỳnh Đức Nguyên', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', 'student', 'nguyen.huynh3103@hcmut.edu.vn', 50, '2024-11-19 10:21:17'),
(2211314, 'Mai Hoàng Huynh', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', 'student', 'huynh.maihoang@hcmut.edu.vn', 10, '2024-12-01 10:23:40'),
(2211441, 'Nguyễn An Khang', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', 'student', 'b.tran@hcmut.edu.vn', 6, '2024-10-19 10:23:40');       


-- Insert data for the SPSO table
INSERT INTO spso (spso_id, name, username, password, dob, email, phone, last_used)
VALUES
(1, 'Nguyễn Phạm Thảo Nguyên', 'admin_thaonguyen', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', '1999-07-03', 'thao.nguyen@hcmut.edu.vn', 123456789, '2024-11-29 18:47:31'),
(2, 'Phương Gia Kiệt', 'admin_giakiet', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', '2001-03-31', 'gia.kiet@hcmut.edu.vn', 123456789, '2024-10-26 00:00:00'),
(3, 'Đinh Hải Nam', 'admin_hainam', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', '2002-02-27', 'hai.nam@hcmut.edu.vn', 123456789, '2024-12-02 00:00:00'),
(4, 'Võ Văn Hiếu', 'admin_vanhieu', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', '1997-05-14', 'van.hieu@hcmut.edu.vn', 123456789, '2024-10-29 18:49:25'),
(5, 'Vũ Đức Toàn', 'admin_ductoan', '$2a$10$kfi60Lqg5/b2PrsTpJ9SMOrufr15jBz/GR0MusAJq9kkF/L/y4arO', '1999-08-16', 'duc.toan@hcmut.edu.vn', 123456789, '2024-11-29 14:27:45');

-- Insert data for the printer table
INSERT INTO printer (printer_id, name, brand, model, description, loc_campus, loc_building, loc_room, status)
VALUES
(1, 'Máy in 1', 'HP', 'HP OfficeJet 8015e', 'Máy in HP OfficeJet 8015 có khả năng in, sao chép, quét và gửi fax một cách hiệu quả. Nó cũng hỗ trợ các tính năng đáng tin cậy như in hai mặt tự động và in từ xa thông qua kết nối Wi-Fi và Bluetooth. Với mẫu mã đẹp và kiểu dáng nhỏ gọn, nó làm cho việc giải quyết các nhu cầu văn phòng dễ dàng hơn.', '1', 'B1', '101', 'running'),
(2, 'Máy in 2', 'HP', 'HP LaserJet MFP 135a (4ZB82A)', 'Máy in HP Laser Trắng đen đa năng In scan copy LaserJet 135a (4ZB82A) thiết kế các mặt tinh xảo, vỏ phủ màu trắng - đen trang nhã, kiểu dáng gọn gàng, tô điểm cho không gian làm việc, sinh hoạt của bạn cao cấp, hiện đại hơn.', '1', 'B1', '105', 'running'),
(3, 'Máy in 3', 'Canon', 'Canon PIXMA GM2070 Wifi', 'Máy in phun đơn năng Canon PIXMA GM2070 sở hữu nét thiết kế hiện đại, vẻ ngoài sang trọng cùng các tính năng in ấn tân tiến, phù hợp để sử dụng trong văn phòng, trường học cũng như các hộ gia đình. Thiết kế hiện đại, đặt thăng bằng trên mọi mặt bàn, tủ. Hiệu suất in cao với tốc độ ổn định.', '1', 'B2', '111', 'running'),
(4, 'Máy in 4', 'Brother', 'Brother DCP-T720DW Wifi', 'Máy in phun màu đa năng In-Scan-Copy Brother DCP-T720DW được cài đặt các chức năng in 2 mặt, in wifi, copy và scan. Hơn nữa, là máy in phun màu, ngoài khả năng in đen trắng, máy còn có thể tạo nên những bản in màu tươi tắn. Phục vụ tốt cho nhu cầu in ấn trong gia đình, công ty quy mô nhỏ với tốc độ in ảnh 17 ảnh/phút (đen trắng), 16.5 ảnh/phút (màu), in trang 30 trang/phút (đen trắng), 26 trang/phút (màu). Công suất in đến 2.500 trang/tháng, in màu xuất trang đầu tiên trong 9.5 giây, in đen trắng chỉ trong 6 giây, giúp rút ngắn thời gian xử lý công việc.', '1', 'A2', '102', 'running'),
(5, 'Máy in 5', 'Canon', 'Canon PIXMA G1020', 'Máy In Phun Màu Đơn Năng Canon PIXMA G1020 đạt hiệu suất in cao, cho ra những bản in chất lượng, sắc nét cùng những tính năng hỗ trợ in ấn từ xa tiết kiệm thời gian, đáp ứng tối ưu cho nhu cầu in ấn của những hộ gia đình hay các doanh nghiệp vừa và nhỏ.', '1', 'A5', '105', 'running'),
(6, 'Máy in 6', 'HP', 'HP LaserJet M211dw Wifi (9YF83A)', 'Máy in HP sở hữu tông màu trắng đen đơn giản mà sang trọng, với chiều dài 356 mm, rộng 216 mm, cao 152.4 mm cho phép đặt ổn định, vững vàng trên mặt kệ tủ, bàn làm việc của bạn.', '2', 'H1', '107', 'running'),
(7, 'Máy in 7', 'Epson', 'Epson EcoTank L3250 Wifi (C11CJ67503)', 'Máy In Phun Màu Đa Năng Epson EcoTank L3250 Wifi (C11CJ67503) có vẻ ngoài gọn đẹp, in ấn linh hoạt với đa dạng chức năng cũng như linh hoạt trong việc kết nối với thiết bị tương thích, đảm bảo chất lượng bản in rõ nét với mực in chuyên dụng cho máy.', '2', 'H2', '107', 'running'),
(8, 'Máy in 8', 'HP', 'HP 107w Wifi (4ZB78A)', 'Máy in HP thiết kế các góc cạnh bo tròn mềm mại, mặt trước in logo thương hiệu nổi bật, kiểu dáng gọn gàng, đặt vững vàng ở nhiều vị trí trong phòng khách, văn phòng làm việc hoặc phòng ngủ của bạn.', '2', 'H6', '106', 'running'),
(9, 'Máy in 9', 'HP', 'HP LaserJet MFP 135a (4ZB82A)', 'Máy in HP Laser Trắng đen đa năng In scan copy LaserJet 135a (4ZB82A) thiết kế các mặt tinh xảo, vỏ phủ màu trắng - đen trang nhã, kiểu dáng gọn gàng, tô điểm cho không gian làm việc, sinh hoạt của bạn cao cấp, hiện đại hơn.', '2', 'H3', '104', 'disabled'),
(10, 'Máy in 10', 'HP', 'HP LaserJet M211d (9YF82A)', 'Máy in HP thiết kế đơn giản, gọn gàng, dễ bố trí ngay trên bàn làm việc với chiều dài 355 mm, rộng 279.5 mm, cao 205 mm và khối lượng chỉ 5.6 kg.', '2', 'H3', '101', 'deleted');

-- Insert data for the document table
INSERT INTO document (document_id, name, file_type, no_of_pages, user_id, printer_id) VALUES
(1, '4_Relational Algebra', 'pdf', 16, 2252542, 3),
(2, 'DS_Ch2_Predicate_Logic_and_Proving_methods', 'pdf', 10, 2213707, 1),
(3, 'Rosen, Kenneth H - Discrete mathematics and its applications-McGraw-Hill (2019)', 'doc', 5, 2213768, 2),
(4, 'AI Technology Advancements Research Project', 'xls', 20, 2213707, 4),  
(5, 'BTL1_MMT', 'pdf', 10, 2252542 , 6),
(6, 'Enterprise Accounting Course Program', 'ppt', 15, 2211314, 5),
(7, 'Huth and Ryan - Logic_in_Computer_Science - Solutions Manual', 'pdf', 37, 2211441, 3),
(8, 'Advanced Calculus Course Final Grades', 'doc', 12, 2211314, 7),
(9, 'Peter Linz - An Introduction to Formal Languages and Automata', 'pdf', 18, 2213707, 9),
(10, 'Calculus, A coplete course, Robert A. Adam, Christopher Essex 2010', 'pdf', 10, 2252868, 8),
(11, '5_SQL', 'pdf', 6, 2213707, 1),
(12, 'Computer Networking', 'pdf', 40, 2252542, 5),
(13, 'Introduction to AI', 'pdf', 30, 2211314, 6),
(14, 'Introduction Machine Learning', 'ppt', 10, 2252868, 5);

-- Insert data for the print_order table
INSERT INTO print_order (print_id, side, page_size, orientation, pages_per_sheet, scale, time_start, time_end, status, pages_to_be_printed, num_pages_printed, document_id, user_id) VALUES
(1, '1', 'A4', 'portrait', 1, 1.00, '2024-10-01 10:00:00', '2022-10-01 10:00:00', 'progress', '8-15', 8, 3, 2252542),
(2, '1', 'A4', 'portrait', 1, 1.00, '2022-11-01 17:30:00', '2022-11-01 18:30:00', 'success', '5-15', 11, 9, 2213707),
(3, '1', 'A4', 'portrait', 1, 0.90, '2022-11-22 16:00:00', '2022-11-22 17:55:00', 'success', '5-10', 6, 1, 2213768),
(4, '1', 'A4', 'portrait', 1, 0.50, '2024-03-01 14:00:00', '2024-03-01 15:00:00', 'failed', '3-7', 0, 6, 2213707),
(5, '2', 'A3', 'landscape', 2, 1.50, '2024-05-01 18:00:00', '2024-05-01 19:30:00', 'failed', 'All', 0, 10, 2252542),
(6, '1', 'A4', 'portrait', 1, 1.00, '2024-05-01 15:30:00', '2024-05-01 15:30:00', 'progress', '10-20', 11, 7, 2211314),
(7, '1', 'A4', 'portrait', 1, 0.60, '2024-07-01 11:30:00', '2024-10-19 10:23:40', 'pending', 'All', 20, 4, 2211441),
(8, '2', 'A3', 'landscape', 2, 0.78, '2024-12-01 16:00:00', '2024-12-01 17:30:00', 'pending', 'All', 3, 8, 2211314),
(9, '2', 'A3', 'landscape', 2, 0.85, '2024-12-01 13:00:00', '2024-12-01 14:30:00', 'success', '1-6', 2, 5, 2213707),
(10, '2', 'A3', 'landscape', 2, 0.90, '2024-12-01 09:00:00', '2024-12-01 10:30:00', 'failed', '1-3', 0, 2, 2252868),
(11, '2', 'A4', 'portrait', 2, 0.90, '2024-11-29 13:00:00', '2024-11-29 14:19:03', 'success', 'All', 2, 11, 2213707),
(12, '2', 'A4', 'portrait', 2, 1.00, '2024-11-19 9:05:00', '2024-11-19 10:21:17', 'success', '1-20', 5, 12, 2252542),
(13, '2', 'A4', 'landscape', 2, 1.00, '2024-03-01 08:00:00', '2024-12-01 10:23:40', 'progress', 'All', 8, 13, 2211314),
(14, '2', 'A4', 'portrait', 2, 1.20, '2024-10-29 12:00:00', '2024-10-29 14:17:15', 'success', 'All', 3, 14, 2252868);

-- Insert data for the Purchase order table
INSERT INTO purchase_order (purchase_id, time, amount, price, status, user_id) VALUES
(1, '2024-11-01 08:00:00', 50, 25000, 'unpaid', 2252542),
(2, '2024-11-01 09:00:00', 3, 1500, 'paid', 2213768),
(3, '2024-11-01 10:00:00', 80, 40000, 'paid', 2213707),
(4, '2024-11-01 11:00:00', 26, 13000, 'paid', 2252868),
(5, '2024-12-01 12:00:00', 6, 3000, 'unpaid', 2252542),
(6, '2024-12-01 13:00:00', 14, 7000, 'paid', 2211314),
(7, '2024-12-01 14:00:00', 7, 3500, 'unpaid', 2211441),
(8, '2024-12-01 15:00:00', 100, 50000, 'paid', 2213707),
(9, '2024-12-01 16:00:00', 90, 45000, 'paid', 2252868),
(10, '2024-12-01 17:00:00', 50, 25000, 'paid', 2211314),
(11, '2024-12-01 10:00:00', 80, 40000, 'unpaid', 2213768),
(12, '2024-12-01 10:00:00', 20, 10000, 'unpaid', 2211441);