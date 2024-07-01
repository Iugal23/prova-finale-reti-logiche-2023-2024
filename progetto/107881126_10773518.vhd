library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
port (
i_clk : in std_logic;
i_rst : in std_logic;
i_start : in std_logic;
i_add : in std_logic_vector(15 downto 0);
i_k : in std_logic_vector(9 downto 0);
o_done : out std_logic;
o_mem_addr : out std_logic_vector(15 downto 0);
i_mem_data : in std_logic_vector(7 downto 0);
o_mem_data : out std_logic_vector(7 downto 0);
o_mem_we : out std_logic;
o_mem_en : out std_logic
);
end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is

component contatore is
port(
i_clk: in std_logic;
i_rst: in std_logic;
i_ec: in std_logic;
i_k: in std_logic_vector (9 downto 0);
o_j: out std_logic_vector(10 downto 0)
);
end component;

component fsm is
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
end component;

signal ec : std_logic;
signal j : std_logic_vector (10 downto 0);

begin

    cnt : contatore port map(
       i_clk => i_clk,
       i_rst => i_rst,
       i_ec => ec,
       i_k => i_k,
       o_j=>j
    );
    
    fsm_map: fsm port map(
        i_start => i_start,
        i_clk => i_clk,
        i_rst => i_rst,
        i_add => i_add,
        i_k => i_k,
        i_j => j,
        i_mem_data => i_mem_data,
        
        o_done => o_done,
        o_mem_we => o_mem_we,
        o_mem_en => o_mem_en,
        o_ec => ec,
        o_mem_add => o_mem_addr,
        o_mem_data => o_mem_data
    );

end;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity contatore is
port(
i_clk: in std_logic;
i_rst: in std_logic;
i_ec: in std_logic;
i_k: in std_logic_vector (9 downto 0);

o_j: out std_logic_vector (10 downto 0)

);
signal cnt:std_logic_vector (10 downto 0);
end contatore;

architecture contatore_arch of contatore is

begin

process(i_clk,i_rst,i_k,i_ec)
variable temp: unsigned (10 downto 0);
begin
temp:=unsigned(cnt);
if (i_rst='1') then
        cnt <= (others => '0');
elsif (i_clk'event and i_clk='1') then 
    if(temp = 2*unsigned(i_k) +1) then
        cnt <= (others => '0');
    elsif (i_ec = '1') then
        cnt <= std_logic_vector(temp + 1);
    end if;
end if;
end process;
o_j<=cnt;
end;

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
            else -- start e' basso, torno allo stato iniziale 
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
                    if (i_j = "00000000001") then -- il primo valore della sequenza e' zero, metto a zero la sua credibilità
                        o_mem_we <= '1';
                        o_mem_en <= '1';
                        o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j));
                        o_ec <= '0';
                        o_done <= '0';
                        o_mem_data <= (others => '0');
                        NEXT_STATE <= NXT_WRD;
                    else  -- il valore letto e' zero ma non sto leggendo il primo valore, vado a leggere la credibilità del precedente valore nella sequenza
                        o_mem_en <= '1';
                        o_mem_we <= '0';
                        o_ec <= '0';
                        o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 2); -- in questo momento il segnale i_j mi indica l'offset della credibiltà del valore corrente, la credibilità del valore precedente si trova due parole prima
                        o_done <= '0';
                        o_mem_data <= (others => '0');
                        NEXT_STATE <= RD_PRE_C;
                    end if;
                else  -- il valore letto non e' zero, metto la sua credibilità a 31
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
            else -- start e' basso, torno allo stato iniziale 
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
            else -- start e' basso, torno allo stato iniziale
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when RD_PRE_V =>
            if (i_start = '1') then -- leggo l'ultimo valore valido
                o_mem_we <= '0';
                o_mem_en <= '1';
                o_ec <= '0';
                o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 3); -- in questo momento il segnale i_j mi indica l'offset della credibiltà del valore corrente, l'ultimo valore valido si trova 3 parole prima
                o_done <= '0';
                o_mem_data <= (others => '0');
                NEXT_STATE <= WR_PRE_V;
            else  -- start e' basso, torno allo stato iniziale
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
                o_mem_add <= std_logic_vector(UNSIGNED(i_add) + UNSIGNED(i_j) - 1); -- in questo momento il segnale i_j mi indica l'offset della credibilta'� del valore corrente, il valore corrente � la parola precedente
                o_mem_data <= i_mem_data;
                o_mem_we <= '1';
                o_mem_en <= '1';
                o_ec <= '1';
                o_done <= '0';
                NEXT_STATE <= START;
            else  -- start e' basso, torno allo stato iniziale
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;            
            end if;
        when DONE_UP =>
            if (i_start = '0') then -- i_start si e' abbassato, mantengo o_done alto per un altro ciclo di clock
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '1';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= DONE_DW;
            else -- start e' basso, torno allo stato iniziale
                o_mem_we <= '0';
                o_mem_en <= '0';
                o_ec <= '0';
                o_done <= '1';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            end if;
        when DONE_DW =>
            if (i_start = '0') then -- abbasso o_done, l'esecuzione e' terminata torno allo stato iniziale
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_ec <= '0';
                o_done <= '0';
                o_mem_add <= (others => '0');
                o_mem_data <= (others => '0');
                NEXT_STATE <= RST;
            else -- i_start si e' alzato di nuovo, ricomincio l'esecuzione
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