Asynchronous FIFO is FIFO where two clock domains(write clock and read clock ) are asynchronous.
To achieve the synchronization for full and empty condition, Two stage synchronizer is used.
Gray code pointers used to avoid false full.Extra bit for pointer is used to aviod confusion between empty and full condition

