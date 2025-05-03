# SHIPMENT APP

## API Documentation for Sender
### LIST STATUS SHIFTMENT
- **Method**: GET
- **Endpoint**: `/shipment-status`
- **Header**: `Content-Type: application/json`
- **Response Success**
    ```json
    {
        "status": true,
        "data": [
            {
                "id": "ID",
                "status": "IN PROCESS",
            },
            {
                "id": "ID",
                "status": "ON DELIVERY",
            },
            {
                "id": "ID",
                "status": "ARRIVED",
            },
            {
                "id": "ID",
                "status": "FINISHED",
            },
            {
                "id": "ID",
                "status": "CANCELED",
            }
        ]
    }
    ```
- **Response Failed**
    ```json
    {
        "status": false,
        "message": "Item not found"
    }
    ```

### LIST SHIFTMENT
- **Method**: GET
- **Endpoint**: `/shipment-list`
- **Header**: `Content-Type: application/json`
- **Response Success**
    ```json
    {
        "status": true,
        "data": [
            {
                "id": "ID",
                "status": "IN PROCESS",
                "item": "Tas Kucing",
                "expedition": "JNE",
            },
            {
                "id": "ID",
                "status": "ON DELIVERY",
                "item": "Kandang Marmut Besi",
                "expedition": "SiCepat",
            },
            {
                "id": "ID",
                "status": "ARRIVED",
                "item": "Pakaian Kucing",
                "expedition": "J&T",
            },
        ]
    }
    ```
- **Response Failed**
    ```json
    {
        "status": false,
        "message": "Item not found"
    }
    ```
### Create Shiftment
- **Method**: POST
- **Endpoint**: `/shipment`
- **Header**: `Content-Type: application/json`
- **Body**:
    ```json
    {
        "item": "Kandang Marmut Besi",
        "expedition": "SiCepat",
        "status": "IN PROCESS",
    }
    ```
- **Response Success**
    ```json
    {
        "status": true,
        "message": "Shiftment created successfully"
    }
    ```
- **Response Failed**
    ```json
    {
        "status": false,
        "message": "Failed to create shiftment"
    }
    ```
### Update Shiftment Status
- **Method**: PUT
- **Endpoint**: `/shipment/:ID`
- **Header**: `Content-Type: application/json`
- **Parameter**:
    - `ID`: ID of the item to update
- **Body**:
    ```json
    {
        "status": "ON DELIVERY",
    }
    ```
- **Response Success**
    ```json
    {
        "status": true,
        "message": "Shiftment updated successfully"
    }
    ```
- **Response Failed**
    ```json
    {
        "status": false,
        "message": "Failed to update shiftment"
    }
    ```

### Delete Shiftment
- **Method**: DELETE
- **Endpoint**: `/shipment/:ID`
- **Header**: `Content-Type: application/json`
- **Parameter**:
    - `ID`: ID of the item to delete
- **Response Success**
    ```json
    {
        "status": true,
        "message": "Shiftment deleted successfully"
    }
    ```
- **Response Failed**
    ```json
    {
        "status": false,
        "message": "Failed to delete shiftment"
    }
    ```

### Add History
- **Method**: POST
- **Endpoint**: `/shipment/:ID/history`
- **Header**: `Content-Type: form-data`
- **Parameter**:
    - `ID`: ID of the item to add history for
- **Body**:
    ```json
    {
        "description": "Pesanan Diterima",
        "time": "2023-10-01T12:00:00Z",
        "image": "File"
    }
    ```
- **Response Success**
    ```json
    {
        "status": true,
        "message": "History added successfully"
    }
    ```
- **Response Failed**
    ```json
    {
        "status": false,
        "message": "Failed to add history"
    }
    ```

## API Documentation for Receiver/Client
### SEARCH BY ID
- **Method**: GET
- **Endpoint**: `/shipment/:ID`
- **Header**: `Content-Type: application/json`
- **Parameter**:
    - `ID`: ID of the item to search for
- **Response Success**
    ```json
    {
        "status": true,
        "data": {
            "id": "ID",
            "status": "ON DELIVERY",
            "item": "Kandang Marmut Besi",
            "expedition": "SiCepat",
            "history": [
                {
                    "description": "Pesanan Diterima",
                    "time": "2023-10-01T12:00:00Z",
                    "image": "https://example.com/image1.jpg"
                },
                {
                    "description": "Dalam perjalanan ke lokasi tujuan",
                    "time": "2023-10-01T12:00:00Z"
                },
                {
                    "description": "Dalam Proses Sortir",
                    "time": "2023-10-01T12:00:00Z"
                }
                {
                    "description": "Tiba di Gudang",
                    "time": "2023-10-01T12:00:00Z",
                },
                {
                    "description": "Diambil Kurir",
                    "time": "2023-10-02T12:00:00Z"
                },
                {
                    "description": "Dalam Pengemasan",
                    "time": "2023-10-03T12:00:00Z"
                }
            ]
        }
    }
    ```
- **Response Failed**
    ```json
    {
        "status": false,
        "message": "Item not found"
    }
    ```