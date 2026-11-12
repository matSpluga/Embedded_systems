void formatWrite(char type, int number, char* tx_buffer) {
    int tens = (number / 10) % 10;
    int ones = number % 10;

    tx_buffer[0] = type;
    tx_buffer[1] = '=';
    tx_buffer[2] = '0' + tens;  
    tx_buffer[3] = '0' + ones;  
    tx_buffer[4] = '\n';        
    tx_buffer[5] = '\0';        
}