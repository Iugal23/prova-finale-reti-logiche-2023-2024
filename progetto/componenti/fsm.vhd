library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fsm is
port(
i_start: in std_logic;
i_clk: in std_logic;
i_rst: in std_logic;
i_add: in std_logic_vector (15 downto 0);
i_k: in std_logic_vector (9 downto 0);
i_j: in std_logic_vector (10 downto 0);
i_mem_data: in std_logic_vector (7 downto 0);

o_done: out std_logic;
o_mem_we: out std_logic;
o_mem_en: out std_logic;
o_ec: out std_logic;
o_mem_add: out std_logic_vector (15 downto 0);
o_mem_data: out std_logic_vector (7 downto 0)
);
end fsm;

architecture fsm_arch of fsm is
type state_type is (RST, START, RD_VAL, NXT_WRD, RD_PRE_C, RD_PRE_V, WR_PRE_V, DONE_UP, DONE_DW);
signal CURRENT_STATE, NEXT_STATE: state_type;
begin
combin: process (i_clk, i_rst,CURRENT_STATE,i_start,i_k,i_mem_data, i_j, i_add)
begin
    if(i_rst='1')then
        CURRENT_STATE <= RST;
        o_done <= '0';
        o_mem_en <= '0';
        o_mem_we <= '0';
        o_ec <= '0'; 
        o_mem_add <= (others => '0');
        o_mem_data <= (others => '0');
    elsif(i_clk'event and i_clk='1')then  
         CURRENT_STATE<= NEXT_STATE; 
    end if;
    case CURRENT_STATE is
        when RST =>
            if (i_start = '1') then
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= START;
            else 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when START =>
            if(i_start = '1' ) then
                if (unsigned(i_j)=2*unsigned(i_k)) then --una volta lette tutte le K parole alzo o_done
                    o_mem_en <= '0';
                    o_mem_we <= '0';
                    o_ec <= '0';
                    o_done <= '1';
                    o_mem_add <= (others => '0');
                    o_mem_data <= (others => '0');
                    NEXT_STATE <= DONE_UP;
                else --leggo il valore corrente
                    o_mem_we <= '0';
                    o_mem_en <= '1';
                    o_mem_add <= std_logic_vector(UNSIGNED(i_add)+UNSIGNED(i_j));
                    o_ec <= '1'; -- alzo il counter per poter scrivere/leggere la credibilità nel prossimo stato
                    o_done <= '0';
                    o_mem_data <= (others => '0');
                    NEXT_STATE <= RD_VAL;
                 end if;
            else -- start è basso, torno allo stato iniziale 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when RD_VAL =>
            if (i_start = '1') then
                if(i_mem_data = "00000000") then
                    if (i_j = "00000000001") then -- il primo valore della sequenza è zero, metto a zero la sua credibilità
                        o_mem_we <= '1';
                        o_mem_en <= '1';
                        o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j));
                        o_ec <= '0';
                        o_done <= '0';
                        o_mem_data <= (others => '0');
                        NEXT_STATE <= NXT_WRD;
                    else  -- il valore letto è zero ma non sto leggendo il primo valore, vado a leggere la credibilità del precedente valore nella sequenza
                        o_mem_en <= '1';
                        o_mem_we <= '0';
                        o_ec <= '0';
                        o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 2); -- in questo momento il segnale i_j mi indica l'offset della credibiltà del valore corrente, la credibilità del valore precedente si trova due parole prima
                        o_done <= '0';
                        o_mem_data <= (others => '0');
                        NEXT_STATE <= RD_PRE_C;
                    end if;
                else  -- il valore letto non è zero, metto la sua credibilità a 31
                    o_mem_we <= '1';
                    o_mem_en <= '1';
                    o_ec <= '0';
                    o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j));
                    o_mem_data <= "00011111";
                    o_done <= '0';
                    NEXT_STATE <= NXT_WRD;
                end if;
            else -- start � basso, torno allo stato iniziale 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when NXT_WRD =>
            if (i_start = '1') then -- alzo il contatore per leggere il prossimo valore
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '1';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= START;
            else -- start � basso, torno allo stato iniziale 
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when RD_PRE_C =>
            if (i_start = '1') then
                if (i_mem_data = "00000000") then -- il valore precedente ha credibilità zero, lascio la credibilità del valore corrente a 0
                    o_mem_en <= '0';
                    o_mem_we <= '0';
                    o_ec <= '0';
                    o_done <= '0';
                    o_mem_add <= (others => '0');
                    o_mem_data <= (others => '0');
                    NEXT_STATE <= NXT_WRD;
                else -- il valore precedente non ha credibilità zero, copio la credibilità del valore precedente decrementadola di 1
                    o_mem_en <= '1';
                    o_mem_we <= '1';
                    o_ec <= '0';
                    o_mem_data <= std_logic_vector(UNSIGNED(i_mem_data) - 1);
                    o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j)); --in questo momento il segnale i_j mi indica l'offset della credibiltà del valore corrente
                    o_done <= '0';
                    NEXT_STATE <= RD_PRE_V;
                end if;
            else -- start � basso, torno allo stato iniziale
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when s5 =>
            if (i_start = '1') then -- leggo l'ultimo valore valido
                o_mem_we <= '0';
                o_mem_en <= '1';
                o_ec <= '0';
                o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 3); -- in questo momento il segnale i_j mi indica l'offset della credibiltà del valore corrente, l'ultimo valore valido si trova 3 parole prima
                o_done <= '0';
                o_mem_data <= (others => '0');
                NEXT_STATE <= WR_PRE_V;
            else  -- start è basso, torno allo stato iniziale
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when WR_PRE_V =>
            if (i_start = '1') then -- scrivo l'ultimo valore valido
                o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 1); -- in questo momento il segnale i_j mi indica l'offset della credibiltà del valore corrente, il valore corrente è la parola precedente
                o_mem_data <= i_mem_data;
                o_mem_we <= '1';
                o_mem_en <= '1';
                o_ec <= '1';
                o_done <= '0';
                NEXT_STATE <= START;
            else  -- start è basso, torno allo stato iniziale
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;            
            end if;
        when DONE_UP =>
            if (i_start = '0') then -- i_start si è abbassato, mantengo o_done alto per un altro ciclo di clock
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '1';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= DONE_DW;
            else -- start è basso, torno allo stato iniziale
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '1';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when DONE_DW =>
            if (i_start = '0') then -- abbasso o_done, l'esecuzione è terminata torno allo stato iniziale
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            else -- i_start si è alzato di nuovo, ricomincio l'esecuzione
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= START;
            end if;    
    end case;
end process;

end;