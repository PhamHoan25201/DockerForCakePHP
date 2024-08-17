# Sử dụng image PHP 8.2.0 với Apache làm base image. Chỉ định kiến trúc amd64
FROM --platform=linux/amd64 php:8.2.0-apache AS base

# Đặt thư mục làm việc hiện tại trong container là /var/www/html
WORKDIR /var/www/html

# Kích hoạt module Rewrite của Apache
# Module Rewrite cho phép bạn sử dụng các quy tắc để thay đổi URL và làm cho chúng thân thiện hơn với SEO
RUN a2enmod rewrite

# Cài đặt các thư viện phụ thuộc cơ bản cho việc phát triển và biên dịch phần mềm
# - libssl-dev                    # Thư viện phát triển cho OpenSSL (bảo mật)
# - build-essential               # Bao gồm các công cụ cần thiết cho việc biên dịch phần mềm (gcc, g++, make)
# - autoconf                      # Công cụ để tạo các tập tin cấu hình tự động
# - pkg-config                    # Công cụ giúp xác định các thư viện cài đặt trên hệ thống
# - gnupg                         # Công cụ để quản lý và xác thực chữ ký PGP
# - curl                          # Công cụ để thực hiện các yêu cầu HTTP
# - libicu-dev                    # Thư viện ICU để hỗ trợ quốc tế hóa (i18n)
# - unzip \ zip                   # Công cụ để nén và giải nén các tệp
# - unixodbc                      # Thư viện ODBC cho kết nối cơ sở dữ liệu
# - unixodbc-dev                  # Thư viện phát triển cho ODBC
# - libmysqlclient-dev            # Thư viện phát triển cho MySQL client
# - rm -rf /var/lib/apt/lists/*   # Xóa các danh sách gói không còn cần thiết để giảm kích thước của image
RUN apt-get update && apt-get install -y \
    libssl-dev \                   
    build-essential \              
    autoconf \                     
    pkg-config \                  
    gnupg \                        
    curl \                         
    libicu-dev \                  
    unzip zip \                 
    unixodbc \                      
    unixodbc-dev \                 
    libmariadb-dev \          
    && rm -rf /var/lib/apt/lists/*

# Thêm kho lưu trữ Microsoft và cài đặt ODBC Driver cho SQL Server
# - ACCEPT_EULA=Y apt-get install -y msodbcsql17   # Cài đặt ODBC Driver cho SQL Server và chấp nhận thỏa thuận cấp phép
# - apt-get clean                                  # Dọn dẹp các tệp cache không cần thiết
# - rm -rf /var/lib/apt/lists/*                    # Xóa các danh sách gói để giảm kích thước của image
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \ 
    && apt-get clean \                          
    && rm -rf /var/lib/apt/lists/*              

# Sao chép Composer từ image composer:latest vào container
# Composer là công cụ quản lý phụ thuộc PHP
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cài đặt các extension PHP cần thiết
# - gettext: Cung cấp các chức năng dịch nội dung
# - intl: Hỗ trợ quốc tế hóa (i18n)
# - pdo_mysql: Cung cấp hỗ trợ PDO cho MySQL
RUN docker-php-ext-install gettext intl pdo_mysql

# Cập nhật kênh PECL để nhận phiên bản mới nhất của các extension
RUN pecl channel-update pecl.php.net

# Cài đặt các tiện ích mở rộng SQL Server cho PHP
# - sqlsrv: Extension cho phép PHP giao tiếp với SQL Server
# - pdo_sqlsrv: Extension PDO cho phép PHP giao tiếp với SQL Server thông qua PDO
RUN pecl install sqlsrv-5.12.0 pdo_sqlsrv-5.12.0

# Kích hoạt các tiện ích mở rộng SQL Server
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

# Cài đặt và kích hoạt tiện ích mở rộng XDebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Cấu hình XDebug (Sao chép file cấu hình XDebug từ host vào container)
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini