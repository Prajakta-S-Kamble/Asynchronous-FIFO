Asynchronous FIFO is FIFO where two clock domains(write clock and read clock ) are asynchronous.
To achieve the synchronization for full and empty condition, Two stage synchronizer is used.
Gray code pointers used to avoid false full.Extra bit for pointer is used to aviod confusion between empty and full condition
On reset, both pointers are set to zero.
Write operation: the memory location that is pointed to by the write pointer is written, and then the write pointer is incremented to point to the next location to be written.
Read pointer always points to the current FIFO word to be read.
The FIFO is empty when the read and write pointers are both equal. This condition happens when both pointers are reset to zero during a reset operation, or when the read pointer catches up to the write pointer, having read the last word from the FIFO.
One design technique used to distinguish between full and empty is to add an extra bit to each pointer.
FIFO is empty when both pointers, including the MSBs are equal. And the FIFO is full when both pointers, except the MSBs are equal.
