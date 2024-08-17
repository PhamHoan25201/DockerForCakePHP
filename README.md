# Thiết Lập Môi Trường CakePHP Với Docker

## Thông Tin Người Tạo

- **Họ Và Tên**: Phạm Văn Hoàn (HoanPV)
- **Website**: https://hoanpv.id.vn
- **Vai Trò**: Lập Trình Viên Phần Mềm

____

# Mục lục

- [Công Nghệ Được Sử Dụng](#technology)
- [Cấu trúc thư mục](#directoryStructure)
- [Hướng dẫn sử dụng](#instructionsForUse)
- [Về DockerFile](#aboutDockerFile)
- [Về Docker Compose](#aboutDockerCompose)
- [Về File cấu hình XDebug (xdebug.ini)](#aboutXdebug)
- [Về Make (Makefile)](#aboutMake)
- [Một số lệnh sử dụng trong dự án (Migrations, Seed, Model, View, Controller)](#someCommand)

____

# <a name="content">Nội dung</a>

## <a name="technology">Công Nghệ Được Sử Dụng</a>

### Web Server
- **Apache**: Apache HTTP Server được sử dụng làm web server. Đây là một phần mềm mã nguồn mở phổ biến cho phép phục vụ nội dung web bằng cách phản hồi các yêu cầu từ phía client.

### PHP
- **PHP 8.2.0**: Môi trường được xây dựng trên PHP 8.2.0, một ngôn ngữ kịch bản mã nguồn mở phù hợp cho phát triển web.

### Hệ Quản Trị Cơ Sở Dữ Liệu
- **MySQL**: 
  - **Image**: `mysql:latest`
  - **Mục Đích**: MySQL là một hệ quản trị cơ sở dữ liệu quan hệ mã nguồn mở, được sử dụng để quản lý và lưu trữ dữ liệu ứng dụng.
  
- **SQL Server**:
  - **Image**: `mcr.microsoft.com/mssql/server:2022-latest`
  - **Mục Đích**: Microsoft SQL Server là một hệ quản trị cơ sở dữ liệu quan hệ, do Microsoft phát triển, dùng để xử lý dữ liệu có cấu trúc và cung cấp khả năng truy vấn SQL.

### Tiện Ích Mở Rộng PHP
- **gettext**: Cung cấp hỗ trợ quốc tế hóa cho việc dịch nội dung trong ứng dụng.
- **intl**: Hỗ trợ quốc tế hóa (i18n), như định dạng ngày tháng, số và tiền tệ.
- **pdo_mysql**: Kích hoạt PDO để kết nối và tương tác với cơ sở dữ liệu MySQL.
- **sqlsrv**: Cung cấp hỗ trợ kết nối PHP với SQL Server.
- **pdo_sqlsrv**: Kích hoạt PDO cho SQL Server, cho phép các thao tác cơ sở dữ liệu thông qua PDO.

### XDebug
- **XDebug**: Là một tiện ích mở rộng PHP, được sử dụng để gỡ lỗi và phân tích hiệu năng mã PHP. Nó cung cấp các tính năng hữu ích như theo dõi ngăn xếp, điểm ngắt và kiểm tra biến.

### Quản Lý Gói
- **Composer**: Composer là một công cụ quản lý phụ thuộc cho PHP, cho phép quản lý các thư viện mà dự án của bạn phụ thuộc vào.

### Công Cụ Và Thư Viện Xây Dựng
- **build-essential**: Một gói bao gồm các công cụ phát triển cần thiết như `gcc`, `g++`, và `make`, cần thiết để biên dịch và xây dựng phần mềm từ mã nguồn.
- **libssl-dev**: Tệp phát triển cho OpenSSL, cần thiết cho truyền dữ liệu an toàn.
- **autoconf**: Công cụ tạo tập tin cấu hình tự động, để xây dựng, cấu hình và cài đặt phần mềm.
- **pkg-config**: Công cụ giúp quản lý cờ biên dịch và liên kết cho các thư viện.
- **gnupg**: GNU Privacy Guard, công cụ để giao tiếp an toàn và lưu trữ dữ liệu.
- **curl**: Một công cụ dòng lệnh để chuyển dữ liệu bằng cách sử dụng các giao thức khác nhau, thường dùng để tải tệp hoặc tương tác với các dịch vụ web.
- **libicu-dev**: Tệp phát triển cho Thư viện Các Thành phần Quốc tế hóa (ICU), được sử dụng để hỗ trợ quốc tế hóa.
- **unixodbc** & **unixodbc-dev**: Thư viện và tệp phát triển cho API ODBC, cung cấp giao diện chuẩn để truy cập các hệ quản trị cơ sở dữ liệu.
- **libmariadb-dev**: Tệp phát triển cho MariaDB, một phiên bản phát triển cộng đồng của cơ sở dữ liệu MySQL.
- **msodbcsql17**: ODBC Driver cho SQL Server, được sử dụng để kết nối PHP với Microsoft SQL Server.

## <a name="directoryStructure">Cấu trúc thư mục</a>

```bash
DockerForCakePHP/
    ├── cake-app/
    ├── docker-compose.yml
    ├── Dockerfile
    ├── Makefile
    ├── xdebug.ini
```

* Trong đó:

    * `cake-app`: thư mục chứa source CakePHP

    * `docker-compose.yml`: là file định nghĩa cấu hình các Docker container. Giúp Docker biết được những services cần chạy hay volume, network và chạy các services đó lên cùng một lúc, chúng tách biệt với môi trường bên ngoài.

    * `Dockerfile`: là một tập tin dạng text chứa một tập các câu lệnh để cài đặt các phần mềm và thư viện cần thiết, thiết lập môi trường làm việc, chạy các lệnh cấu hình và thiết lập.

    * `Makefile`: là một file chứa các lệnh để thực thi như: build docker, run migration, seed,...

    * `xdebug.ini`: là file cấu hình cho XDebug

## <a name="instructionsForUse">Hướng dẫn sử dụng</a>

### Bước 1: Tạo dự án cakePHP mới hoặc clone source cakePHP vào folder `cake-app`

* Note: Hãy xóa file `dummy.txt` ở `cake-app/dummy.txt` trước khi thực hiện.

* Trường hợp clone source cakePHP

    1. Clone source vào folder `cake-app`

    2. Mở Terminal và thực hiện di chuyển vào folder `cake-app`

        ```bash
        cd cake-app
        ```

    3. Thực hiện lệnh `composer update` (phải cài composer mới thực hiện được)

        ```bash
        composer update
        ```

        Cài Composer: Hãy tham khảo các bài viết khác về cách cài đặt `Composer`

* Trường hợp tạo dự án cakePHP mới

    * Note: 
        * Trường hợp bạn đã cài đặt `make` và `composer` thì có thể sử dụng lệnh sau để hoàn thành bước 1 bước 2 nhanh chóng:

            ```bash
            make setup-new-project
            ```
        * Để hiểu được `setup-new-project` đang làm gì thì hãy tìm hiểu file `Makefile`

    1. Thực hiện di chuyển vào folder `cake-app`

        ```bash
        cd cake-app
        ```
    2. Tạo dự án cakePHP (trước khi tạo thì cần cài composer) 

         ```bash
        composer create-project --prefer-dist cakephp/app:~4.0 .
        ```   

### Bước 2: Build Docker  (trước khi build thì cần di chuyển ra ngoài thư mục cake-app) 

* Di chuyển ra ngoài một thư mục

    ```bash
    cd ../
    ```  

* Build Docker

    ```bash
    docker compose up -d --build
    ```     
### Bước 3: Một số công việc cần phải làm để sử dụng XDebug

* Note: IDE đang sử dụng là `Visual Studio Code`

* Cần thực hiện một số mội dung sau:

    * Cài Extenstion `PHP Debug` của `XDebug`

    * Tạo file `launch.json` (nếu có file này rồi thì không cần tạo nữa)
        * Từ cửa sổ Visual Studio Code, bạn nhấn vào mục Run and Debug phía trái cửa sổ. Chọn `create a launch.json` . Sau đó file debug config .vscode/launch.json sẽ được tạo ra.

    * Update config của `Listen for Xdebug` thành như sau (thêm config `pathMappings` và `log`):

        ```json
            {
                "name": "Listen for XDebug",
                "type": "php",
                "request": "launch",
                "port": 9003,
                "pathMappings": {
                "/var/www/html": "${workspaceFolder}/cake-app"
                },
                "log": true
            }
        ```

    * Giải thích chi tiết từng thuộc tính:

        * `name`: 

            * `"Listen for XDebug"`: Đây là tên của cấu hình gỡ lỗi, nó sẽ xuất hiện trong danh sách các cấu hình có sẵn trong VS Code. Bạn có thể tùy ý đặt tên này để dễ nhận biết.

        * `type`:

            * `"php"`: Xác định loại ngôn ngữ mà cấu hình này sẽ gỡ lỗi, trong trường hợp này là PHP. VS Code sẽ sử dụng đúng công cụ và trình gỡ lỗi (debugger) cho ngôn ngữ này.

        * `request`:

            * `"launch"`: Xác định hành động mà VS Code sẽ thực hiện. Với giá trị "launch", nó sẽ khởi động một phiên gỡ lỗi mới. Trong trường hợp này, VS Code sẽ lắng nghe (listen) các kết nối gỡ lỗi từ XDebug.

        * `port`:

            * `9003`: Cổng mà VS Code sẽ lắng nghe các kết nối gỡ lỗi từ XDebug. Bạn cần đảm bảo rằng XDebug trên máy chủ PHP của bạn được cấu hình để gửi dữ liệu gỡ lỗi qua cổng này.

        * `pathMappings`: Đây là một đối tượng ánh xạ (mapping) các đường dẫn giữa máy chủ (server) và máy khách (client). Điều này rất quan trọng trong các trường hợp bạn gỡ lỗi một ứng dụng PHP chạy trên một máy chủ từ xa (remote server).

            * `"/var/www/html"`: Đường dẫn trên máy chủ nơi mã nguồn PHP đang chạy.

            * `"${workspaceFolder}/cake-app"`: Đường dẫn tương ứng trên máy của bạn (client) trong VS Code. ${workspaceFolder} là một biến đặc biệt trong VS Code, tự động lấy thư mục gốc của dự án mà bạn đang làm việc.
            
            Với cấu hình này, VS Code hiểu rằng các tập tin trong /var/www/html trên máy chủ sẽ tương ứng với thư mục cake-app trong không gian làm việc (workspace) của bạn.

        * `log`:

            * `true`: Nếu giá trị này được đặt là true, VS Code sẽ ghi log các thông tin liên quan đến gỡ lỗi. Điều này giúp bạn theo dõi chi tiết về quá trình kết nối và gỡ lỗi, rất hữu ích khi cần tìm nguyên nhân nếu có sự cố xảy ra.

### Bước 4: Connect Database

* Note:
    * IDE: `Visusal Studio Code`
    * Tool quản trị cơ sở dữ liệu: `DBeaver`
    * Framework: `CakePHP`

1. **Đối với MySQL**

    * Tại file `config/app_local.php`, update cấu hình thành như sau:

        ```php
        'Datasources' => [
            'default' => [
                'host' => 'mysql_db',
                'username' => 'root',
                'password' => 'root',
                'database' => 'cakephp-app',
                'url' => env('DATABASE_URL', null),
            ],

            ...
        ],
        ```

    * Note:

        * Khi sử dụng tool quản trị cơ sở dữ liệu thì host sẽ được hiểu là `localhost` nên hãy input là `localhost`

        * Thông tin cài đặt cấu hình database có thể update ở file `docker-compose.yml`

        * MySql đã tạo Database `cakephp-app`(cấu hình trong docker compose) khi build docker.


1. **Đối với SQL Server**

    * Tại file `config/app.php`, update cấu hình thành như sau:

        * Khai báo để sử dụng `Sqlserver` class:
        
            ```php
            use Cake\Database\Driver\Sqlserver;
            ```

        * Update cấu hình thành như sau (Chỉ thay đổi cấu hình của `driver`):

            ```php
            'Datasources' => [
                'default' => [
                    'className' => Connection::class,
                    'driver' => Sqlserver::class,
                    'persistent' => false,
                    'timezone' => 'UTC',
                    'flags' => [],
                    'cacheMetadata' => true,
                    'log' => false,
                    'quoteIdentifiers' => false,
                ],

                ...
            ],
            ```
    * Tại file `config/app_local.php`, update cấu hình thành như sau:

        ```php
        'Datasources' => [
            'default' => [
                'host' => 'sql-server',
                'username' => 'sa',
                'password' => 'YourStrong!Passw0rd',
                'database' => 'cakephp-app',
                'url' => env('DATABASE_URL', null),
            ],

            ...
        ],
        ```

    * Note:

        * Khi sử dụng tool quản trị cơ sở dữ liệu thì host sẽ được hiểu là `localhost` nên hãy input là `localhost`

        * Thông tin cài đặt cấu hình database có thể update ở file `docker-compose.yml`

        * SqlServer không thể tạo Database khi build docker. Vì vậy, hãy sử dụng tool quản trị cơ sở dữ liệu để tạo database

## <a name="aboutDockerFile">Về DockerFile</a>

### Giải thích các phần trong DockerFile

1. **Base Image và Thư Mục Làm Việc**

    * `FROM --platform=linux/amd64 php:8.2.0-apache AS base`: Sử dụng image PHP với Apache và chỉ định kiến trúc amd64.

    * `WORKDIR /var/www/html`: Đặt thư mục làm việc hiện tại là /var/www/html.

2. **Kích Hoạt Module Apache**

    * `RUN a2enmod rewrite`: Kích hoạt module rewrite của Apache để sử dụng các quy tắc rewrite URL.

3. **Cài Đặt Các Thư Viện Phụ Thuộc Cơ Bản**

    * `RUN apt-get update && apt-get install -y ...`: Cài đặt các công cụ cơ bản và dọn dẹp các tệp không cần thiết.

4. **Cài Đặt Các Thư Viện Phụ Thuộc cho SQL Server**

    * `RUN curl ...`: Thêm kho lưu trữ Microsoft và cài đặt ODBC Driver cho SQL Server.

5. **Cài Đặt Các Thư Viện Phụ Thuộc cho MySQL**

    * `RUN apt-get update && apt-get install -y ...`: Cài đặt các thư viện cần thiết cho kết nối và phát triển MySQL.

6. **Sao Chép Composer**

    * `COPY --from=composer:latest /usr/bin/composer /usr/bin/composer`: Sao chép Composer từ image composer:latest.

7. **Cài Đặt Các Extension PHP Cần Thiết**

    * `RUN docker-php-ext-install gettext intl pdo_mysql`: Cài đặt các extension PHP cần thiết.

8. **Cập Nhật và Cài Đặt Các Extension SQL Server từ PECL**

    * `RUN pecl channel-update pecl.php.net`: Cập nhật kênh PECL.

    * `RUN pecl install sqlsrv-5.12.0 pdo_sqlsrv-5.12.0`: Cài đặt các tiện ích mở rộng SQL Server.

9. **Kích Hoạt Các Extension SQL Server**

    * `RUN docker-php-ext-enable sqlsrv pdo_sqlsrv`: Kích hoạt các extension SQL Server đã cài đặt.

10. **Cài đặt và kích hoạt tiện ích mở rộng XDebug**

    * `RUN pecl install xdebug \&& docker-php-ext-enable xdebug` : Cài đặt và kích hoạt tiện ích mở rộng XDebug đã cài đặt.

### Ý nghĩa của một số lệnh được sử dụng

* `docker-php-ext-install`: Đây là một script tiện ích đi kèm với các Docker image chính thức của PHP, giúp đơn giản hóa việc cài đặt các extension PHP. Lệnh này sẽ biên dịch và cài đặt các extension PHP từ nguồn.

* `docker-php-ext-enable`: Đây là một script tiện ích đi kèm với các Docker image chính thức của PHP. Nó được sử dụng để kích hoạt các extension PHP mà bạn đã cài đặt.

### Về cài đặt các thư viện phụ thuộc cần thiết

1. **Các lệnh cần thiết khi cài đặt các thư viện phụ thuộc cần thiết**

    1.1 **Lệnh `RUN apt-get update && apt-get install -y \`**

    * `apt-get update`: Lệnh này cập nhật danh sách gói từ các nguồn trong tệp

    * `apt-get install -y`: Lệnh này cài đặt các gói được liệt kê sau đó. Tùy chọn -y tự động chấp nhận các câu hỏi Yes/No (y/n) trong quá trình cài đặt.

    1.2 **Lệnh `&& rm -rf /var/lib/apt/lists/*`**

    * `rm -rf /var/lib/apt/lists/*`: Xóa các danh sách gói đã tải về để giảm kích thước của image Docker. Điều này giúp giảm thiểu không gian lưu trữ sử dụng, vì sau khi cài đặt các gói, thông tin danh sách này không còn cần thiết nữa.

2. **Thư viện SSL (libssl-dev)**
    * `libssl-dev`: Đây là thư viện phát triển cho OpenSSL, một bộ công cụ phần mềm mã nguồn mở cho các ứng dụng yêu cầu bảo mật, chẳng hạn như mã hóa dữ liệu hoặc thiết lập các kết nối an toàn qua HTTPS. Thư viện này cung cấp các tệp tiêu đề cần thiết để xây dựng các ứng dụng yêu cầu bảo mật SSL/TLS.

3. **Công cụ xây dựng (build-essential, autoconf, pkg-config)**

    3.1 `build-essential` là một meta-package 
, được thiết kế để cung cấp một bộ công cụ phát triển cơ bản cần thiết để biên dịch phần mềm từ mã nguồn. Nó bao gồm các gói sau:

    * `gcc`: Trình biên dịch cho ngôn ngữ lập trình C.

    * `g++`: Trình biên dịch cho ngôn ngữ lập trình C++.

    * `make`: Công cụ tự động hóa quy trình xây dựng phần mềm.

    * `libc-dev`: Cung cấp các tệp tiêu đề và thư viện của GNU C Library cần thiết cho biên dịch.

    * Một số công cụ và thư viện khác cần thiết cho quá trình biên dịch.

    3.2 `autoconf`: Một công cụ để tạo các tệp cấu hình cho các gói phần mềm từ mã nguồn. Nó giúp tạo các tệp configure để ứng dụng có thể được xây dựng trên nhiều hệ thống khác nhau.

    3.3 `pkg-config`: Một công cụ để quản lý thông tin về các thư viện được chia sẻ. Nó giúp xác định vị trí các thư viện cần thiết và các cờ biên dịch cần sử dụng.

4. **GnuPG (gnupg)**

    `gnupg`: Là một công cụ mã hóa và xác thực. Nó thường được sử dụng để tải và xác minh chữ ký của các gói phần mềm nhằm đảm bảo rằng chúng không bị thay đổi trong quá trình tải về.

5. **Curl (curl)**

    `curl`: Là một công cụ dòng lệnh để chuyển dữ liệu với cú pháp URL. Nó rất hữu ích cho việc tải xuống các tệp, gửi các yêu cầu HTTP, hoặc giao tiếp với các API từ trong Docker container.

6. **Thư viện quốc tế hóa (libicu-dev)**

    `libicu-dev`: Cung cấp các thư viện và tệp tiêu đề cho ICU (International Components for Unicode). Đây là một tập hợp các thư viện hỗ trợ xử lý văn bản Unicode và quốc tế hóa, rất quan trọng đối với các ứng dụng đa ngôn ngữ.

7. **Công cụ nén và giải nén (unzip, zip)**

    `unzip` và `zip`: Các công cụ này cần thiết để nén và giải nén các tệp. Điều này thường cần thiết khi bạn làm việc với các tệp lưu trữ hoặc khi tải xuống và giải nén các gói phần mềm từ internet.

8. **Gói UnixODBC (unixodbc và unixodbc-dev)**

    * `unixodbc`: Là một bộ điều khiển ODBC (Open Database Connectivity). Nó là một giao thức mà bạn có thể sử dụng để kết nối cơ sở dữ liệu. Một trong những ứng dụng phổ biến của `unixodbc` là kết nối với `Microsoft SQL Server` từ một môi trường không phải Windows

    * `unixodbc-dev`: Cung cấp các tệp tiêu đề và công cụ cần thiết để phát triển các ứng dụng sử dụng `unixodbc`. Nếu bạn đang biên dịch các ứng dụng hoặc module cần kết nối ODBC, bạn sẽ cần thư viện này.

9. **Thư viện MariaDB (libmariadb-dev)**

    `libmariadb-dev`: là một gói phần mềm cung cấp các thư viện cần thiết để phát triển ứng dụng sử dụng với MariaDB hoặc MySQL. Đây là phần quan trọng trong quá trình phát triển phần mềm khi bạn cần kết nối ứng dụng của mình với cơ sở dữ liệu MariaDB hoặc MySQL.

## <a name="aboutDockerCompose">Về Docker Compose</a>

### Giải thích các phần trong Docker Compose (docker-compose.yml)

1. **Tệp Docker Compose**

    ```yaml
    version: '3.8'
    ```

    * `version: '3.8'`: Chỉ định phiên bản của Docker Compose file format mà tệp sử dụng. Phiên bản 3.8 tương thích với Docker Engine 18.06.0+ và cung cấp các tính năng như hỗ trợ mạng overlay và volume driver.

2. **Định Nghĩa Volumes**

    ```yaml
    volumes:
    db-mysql-store:
    db-sqlserver-store:
    ```

    * `volumes:`: Định nghĩa các volumes (khối lượng lưu trữ) mà Docker sẽ quản lý. Volumes giúp lưu trữ dữ liệu bền vững, không bị mất khi container dừng hoặc bị xóa.

        * `db-mysql-store:`: Volume này dùng để lưu trữ dữ liệu của MySQL. Dữ liệu của MySQL sẽ được lưu trong volume này.

        * `db-sqlserver-store:`: Volume này dùng để lưu trữ dữ liệu của SQL Server. Dữ liệu của SQL Server sẽ được lưu trong volume này.

3. **Định Nghĩa Networks**

    ```yaml
    networks:
    network-app:
        driver: bridge
    ```

    * `networks:`: Định nghĩa các mạng mà các container sẽ kết nối với nhau.

        * `network-app:`: Tạo một mạng tên là network-app để các container có thể giao tiếp với nhau.

            * `driver: bridge`: Sử dụng driver mạng bridge để tạo một mạng cầu nối (bridge network), cho phép các container giao tiếp với nhau trên cùng một mạng ảo.

4. **Định Nghĩa Services**

    ```yaml
    services:
    cakephp-app:
        container_name: cakephp-app
        build: .
        volumes:
        - ./cake-app:/var/www/html
        ports:
        - 3000:80
        networks:
        - network-app
    ```

    * `services:`: Định nghĩa các dịch vụ (containers) sẽ được tạo và quản lý bởi Docker Compose.

        * `cakephp-app:`: Dịch vụ cho ứng dụng CakePHP.

            * `container_name: cakephp-app`: Đặt tên container là cakephp-app.

            * `build: .`: Xây dựng image cho container từ Dockerfile trong thư mục hiện tại (.).

            * `volumes:`: Định nghĩa các volume mount (gắn kết volumes) cho container.

                * `./cake-app:/var/www/html`: Mount thư mục `./cake-app ` trên máy chủ vào thư mục `/var/www/html` trong container, nơi ứng dụng CakePHP sẽ được triển khai.

            * `ports:`: Ánh xạ cổng giữa máy chủ và container.

                * `3000:80`: Ánh xạ cổng 3000 của máy chủ với cổng 80 của container, cho phép truy cập ứng dụng CakePHP thông qua cổng 3000 của máy chủ.

            * `networks:`: Kết nối dịch vụ với mạng đã định nghĩa.
                * `network-app`: Kết nối với mạng network-app.

    ```yaml
    mysql_db:
        image: mysql:latest
        environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: cakephp-app
        ports:
        - 3306:3306
        volumes:
        - db-mysql-store:/var/lib/mysql
        networks:
        - network-app
    ```

    * `mysql_db:`: Dịch vụ cho cơ sở dữ liệu MySQL.

        * `image: mysql:latest`: Sử dụng image MySQL mới nhất từ Docker Hub.

        * `environment:`: Định nghĩa các biến môi trường cho container.

            * `MYSQL_ROOT_PASSWORD: root`: Đặt mật khẩu cho tài khoản root của MySQL là root.

            * `MYSQL_DATABASE: cakephp-app`: Tạo cơ sở dữ liệu tên cakephp-app khi container khởi động.

        * `ports:`: Ánh xạ cổng giữa máy chủ và container.

            * `3306:3306`: Ánh xạ cổng 3306 của máy chủ với cổng 3306 của container, cho phép kết nối đến MySQL qua cổng 3306 của máy chủ.

        * `volumes:`: Mount volume cho container.

            * `db-mysql-store:/var/lib/mysql`: Mount volume db-mysql-store vào thư mục /var/lib/mysql trong container, nơi lưu trữ dữ liệu của MySQL.

        * `networks:`: Kết nối dịch vụ với mạng đã định nghĩa.

            * `network-app`: Kết nối với mạng network-app.

    ```yaml
    sql-server:
        image: mcr.microsoft.com/mssql/server:2022-latest
        environment:
        SA_PASSWORD: "YourStrong!Passw0rd"
        ACCEPT_EULA: "Y"
        ports:
        - 1433:1433
        volumes:
        - db-sqlserver-store:/var/opt/mssql
        networks:
        - network-app
    ```

    * `sql-server:`: Dịch vụ cho SQL Server.

        * `image: mcr.microsoft.com/mssql/server:2022-latest`: Sử dụng image SQL Server phiên bản 2022 mới nhất từ Microsoft Container Registry.

        * `environment:`: Định nghĩa các biến môi trường cho container.

            * `SA_PASSWORD: "YourStrong!Passw0rd"`: Đặt mật khẩu cho tài khoản sa (super admin) của SQL Server.

            * `ACCEPT_EULA=Y`: Chấp nhận thỏa thuận cấp phép của SQL Server.

        * `ports:`: Ánh xạ cổng giữa máy chủ và container.

            * `1433:1433`: Ánh xạ cổng 1433 của máy chủ với cổng 1433 của container, cổng mặc định của SQL Server.

        * `volumes:`: Mount volume cho container.

            * `db-sqlserver-store:/var/opt/mssql`: Mount volume db-sqlserver-store vào thư mục /var/opt/mssql trong container, nơi lưu trữ dữ liệu của SQL Server.

        * `networks:`: Kết nối dịch vụ với mạng đã định nghĩa.

            * `network-app`: Kết nối với mạng network-app.

4. **Tóm lại**

* `Volumes`: Được sử dụng để lưu trữ dữ liệu bền vững cho MySQL và SQL Server.

* `Networks`: Được sử dụng để thiết lập mạng cầu nối giúp các container giao tiếp với nhau.

* `Services`: Định nghĩa các dịch vụ cần chạy, bao gồm ứng dụng CakePHP, cơ sở dữ liệu MySQL và SQL Server. Các cấu hình bao gồm image, cổng, biến môi trường, volume mount và mạng kết nối.

## <a name="aboutXdebug">Về File cấu hình XDebug (xdebug.ini)</a>

1. **Giải thích các tham số**
    ```ini
    [xdebug]
    zend_extension=xdebug.so
    xdebug.mode=debug
    xdebug.start_with_request=yes
    xdebug.client_host=host.docker.internal
    xdebug.client_port=9003
    xdebug.log=/var/log/xdebug.log
    ```

    * `zend_extension=xdebug.so`: Đây là cách bạn kích hoạt Xdebug trong PHP. `xdebug.so` là tệp mở rộng (extension) của Xdebug mà PHP sẽ tải. Đường dẫn xdebug.so thường phụ thuộc vào hệ điều hành và cách cài đặt PHP.

    * `xdebug.mode=debug`: Cấu hình chế độ hoạt động của Xdebug. Trong trường hợp này, debug cho phép Xdebug hoạt động ở chế độ gỡ lỗi, giúp bạn thực hiện các phiên gỡ lỗi từ xa hoặc cục bộ. Xdebug có nhiều chế độ khác như trace và profile, nhưng chỉ chế độ debug đang được kích hoạt ở đây.

    * `xdebug.start_with_request=yes`: Khi được thiết lập thành yes, Xdebug sẽ tự động bắt đầu gỡ lỗi khi có một yêu cầu (request) từ trình duyệt hoặc ứng dụng web. Điều này có nghĩa là Xdebug sẽ bắt đầu gỡ lỗi ngay lập tức khi có yêu cầu đến server PHP.

    * `xdebug.client_host=host.docker.internal`: Đây là địa chỉ IP hoặc hostname của máy chủ gỡ lỗi mà Xdebug sẽ gửi các kết nối gỡ lỗi đến. `host.docker.internal` là một hostname đặc biệt được Docker sử dụng để kết nối từ container đến máy chủ của host trong môi trường Docker. Tham số này đảm bảo rằng Xdebug kết nối tới máy chủ gỡ lỗi từ container Docker.

    * `xdebug.client_port=9003`: Cổng mà Xdebug sẽ sử dụng để kết nối với máy chủ gỡ lỗi. `9003` là cổng mặc định cho Xdebug phiên bản 3.x. Trong các phiên bản trước của Xdebug (2.x), cổng mặc định là `9000`.

    * `xdebug.log=/var/log/xdebug.log`: Đường dẫn đến tệp log của Xdebug. Xdebug sẽ ghi lại các thông tin liên quan đến quá trình gỡ lỗi vào tệp này, giúp bạn theo dõi và phân tích các lỗi hoặc vấn đề liên quan đến gỡ lỗi. Đảm bảo rằng thư mục /var/log/ có quyền ghi cho PHP.

2. **Tóm lại**
    * File cấu hình này thiết lập Xdebug để:

        * Kích hoạt gỡ lỗi với zend_extension=xdebug.so.

        * Chạy ở chế độ gỡ lỗi (xdebug.mode=debug).

        * Tự động bắt đầu gỡ lỗi với mỗi yêu cầu (xdebug.start_with_request=yes).

        * Kết nối đến máy chủ gỡ lỗi ở địa chỉ `host.docker.internal` trên cổng `9003` (`xdebug.client_host` và `xdebug.client_port`).

        * Ghi log thông tin gỡ lỗi vào tệp `/var/log/xdebug.log` (`xdebug.log`).

## <a name="aboutMake">Về Make (Makefile)</a>

* `Makefile`: là một file chứa các lệnh để thực thi như: build docker, down docker, prune docker, tạo dự án, run migration, seed,...

* Để sử dụng được `make` thì trước tiên cần phải cài đặt. Tùy từng hệ điều hành sẽ có cách cài khác nhau. Hãy tham khảo các bài viết khác về cách cài đặt `make`

* Cú pháp để sử dụng như sau:

    ```bash
    make setup-new-project
    ```

    * Trong đó `setup-new-project` là tập hợp lệnh đã được cấu hình trong `Makefile`

## <a name="someCommand">Một số lệnh sử dụng trong dự án (Migration, Seed, Model, View, Controller)</a>

* CẢNH BÁO: Vì chạy ở docker nên sẽ có một số lệnh cần phải trỏ trức tiếp đến folder ở docker mới thực thi được. Vì vậy, khi `prune` thì một số file được tạo bằng cách trỏ trực tiếp đến folder ở docker thì có thể mất.

* Một số lệnh của CakePHP được sử dụng(chi tiết xem thêm ở file `Makefile`):

    ```
    Tạo dự án:
        composer create-project --prefer-dist cakephp/app:~4.0 .

    Tạo file Migations:
        bin/cake bake migration CreateUsers

    Tạo file Seed:
        bin/cake bake seed Users

    Chạy Migrations:
        docker exec cakephp-app bash -c "bin/cake migrations migrate"

    Rollback Migrations:
        docker exec cakephp-app bash -c "bin/cake migrations rollback"

    Chạy Seed:
        docker exec cakephp-app bash -c "bin/cake migrations seed"

    Cài đặt Faker (thư viện data ảo):
        cd cake-app && composer require fakerphp/faker

    Tạo file Model (Users):
        docker exec cakephp-app bash -c "bin/cake bake model Users"

    Tạo file Controller (Users):
        cd cake-app && bin/cake bake controller Users

    Tạo file Template:
        docker exec cakephp-app bash -c "bin/cake bake template Users"

    ```