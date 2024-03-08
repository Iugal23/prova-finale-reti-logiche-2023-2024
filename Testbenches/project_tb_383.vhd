-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_383 is
end project_tb_383;

architecture project_tb_arch_383 of project_tb_383 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 860;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,77,0,173,0,195,0,209,0,243,0,14,0,163,0,3,0,10,0,0,0,234,0,200,0,35,0,0,0,58,0,0,0,134,0,0,0,199,0,215,0,191,0,17,0,198,0,0,0,225,0,160,0,0,0,252,0,180,0,65,0,0,0,0,0,74,0,232,0,0,0,47,0,220,0,0,0,191,0,0,0,0,0,0,0,172,0,31,0,206,0,9,0,129,0,65,0,0,0,155,0,194,0,218,0,153,0,20,0,99,0,0,0,99,0,182,0,223,0,163,0,0,0,176,0,53,0,74,0,0,0,85,0,86,0,34,0,0,0,253,0,0,0,0,0,156,0,117,0,0,0,179,0,0,0,0,0,202,0,206,0,28,0,47,0,109,0,0,0,197,0,0,0,207,0,66,0,223,0,17,0,152,0,104,0,0,0,207,0,154,0,129,0,118,0,42,0,0,0,115,0,233,0,245,0,14,0,162,0,159,0,93,0,33,0,0,0,0,0,236,0,96,0,51,0,151,0,0,0,0,0,121,0,97,0,0,0,241,0,33,0,2,0,0,0,0,0,59,0,98,0,185,0,161,0,64,0,200,0,206,0,141,0,197,0,192,0,0,0,24,0,0,0,185,0,122,0,146,0,0,0,61,0,19,0,28,0,75,0,216,0,0,0,0,0,87,0,218,0,211,0,236,0,42,0,0,0,161,0,0,0,253,0,157,0,128,0,85,0,0,0,206,0,178,0,158,0,199,0,21,0,0,0,0,0,220,0,73,0,165,0,126,0,161,0,0,0,116,0,240,0,72,0,237,0,142,0,165,0,42,0,111,0,36,0,0,0,34,0,0,0,120,0,0,0,123,0,203,0,237,0,68,0,15,0,170,0,125,0,60,0,7,0,64,0,123,0,0,0,213,0,0,0,11,0,227,0,151,0,0,0,54,0,0,0,39,0,183,0,0,0,179,0,198,0,0,0,210,0,227,0,0,0,142,0,44,0,67,0,0,0,185,0,208,0,141,0,62,0,44,0,91,0,77,0,251,0,224,0,173,0,170,0,75,0,237,0,115,0,0,0,146,0,96,0,0,0,162,0,184,0,235,0,0,0,65,0,51,0,156,0,0,0,96,0,191,0,245,0,0,0,238,0,18,0,28,0,151,0,160,0,50,0,44,0,240,0,163,0,183,0,0,0,200,0,92,0,163,0,229,0,112,0,245,0,0,0,94,0,167,0,47,0,171,0,185,0,236,0,0,0,212,0,188,0,98,0,89,0,220,0,251,0,120,0,135,0,90,0,167,0,17,0,39,0,104,0,0,0,79,0,50,0,104,0,208,0,140,0,83,0,7,0,203,0,0,0,255,0,64,0,0,0,163,0,11,0,112,0,130,0,214,0,57,0,246,0,49,0,145,0,44,0,23,0,253,0,238,0,113,0,0,0,35,0,196,0,0,0,247,0,214,0,180,0,211,0,249,0,155,0,27,0,123,0,86,0,135,0,0,0,84,0,97,0,0,0,58,0,0,0,0,0,160,0,228,0,0,0,137,0,240,0,233,0,57,0,155,0,101,0,120,0,208,0,64,0,44,0,195,0,105,0,71,0,18,0,221,0,77,0,140,0,129,0,0,0,11,0,27,0,146,0,248,0,0,0,251,0,36,0,202,0,250,0,132,0,72,0,2,0,22,0,114,0,117,0,234,0,0,0,208,0,51,0,111,0,185,0,185,0,205,0,0,0,0,0,12,0,181,0,216,0,176,0,159,0,163,0,231,0,131,0,157,0,219,0,74,0,91,0,7,0,208,0,163,0,0,0,221,0,65,0,144,0,241,0,27,0,0,0,0,0,238,0,224,0,81,0,29,0,47,0,0,0,11,0,148,0,29,0,189,0,62,0,193,0,130,0,129,0,34,0,0,0,206,0,0,0,34,0,188,0,0,0,0,0,56,0,183,0,169,0,116,0,0,0,20,0,205,0,122,0,207,0,0,0,0,0,0,0,122,0,147,0,226,0,176,0,209,0,120,0,223,0,93,0,0,0,77,0,105,0,168,0,147,0,86,0,119,0,85,0,174,0,0,0,111,0,0,0,0,0,197,0,164,0,162,0,157,0,162,0,79,0,137,0,121,0,189,0,203,0,0,0,29,0,225,0,53,0,170,0,153,0,127,0,201,0,147,0,147,0,0,0,226,0,97,0,93,0,72,0,140,0,45,0,138,0,149,0,176,0,64,0,112,0,66,0,248,0,107,0,107,0,32,0,0,0,120,0,0,0,252,0,156,0,11,0,0,0,121,0,63,0,169,0,219,0,146,0,26,0,119,0,148,0,186,0,104,0,180,0,40,0,225,0,0,0,32,0,223,0,168,0,180,0,107,0,190,0,246,0,225,0,11,0,92,0,26,0,120,0,40,0,0,0,0,0,37,0,230,0,44,0,53,0,166,0,3,0,110,0,84,0,63,0,16,0,180,0,28,0,66,0,204,0,238,0,201,0,232,0,64,0,224,0,147,0,0,0,6,0,233,0,215,0,232,0,57,0,0,0,203,0,66,0,222,0,127,0,156,0,0,0,144,0,0,0,170,0,11,0,0,0,164,0,135,0,0,0,0,0,193,0,218,0,140,0,0,0,243,0,59,0,0,0,153,0,113,0,156,0,41,0,46,0,138,0,242,0,218,0,168,0,183,0,0,0,169,0,218,0,127,0,224,0,13,0,0,0,135,0,53,0,217,0,50,0,94,0,137,0,6,0,22,0,1,0,0,0,202,0,253,0,63,0,250,0,142,0,174,0,0,0,138,0,129,0,166,0,115,0,205,0,54,0,54,0,193,0,61,0,14,0,134,0,147,0,0,0,0,0,107,0,147,0,149,0,0,0,237,0,158,0,28,0,156,0,12,0,0,0,248,0,201,0,0,0,31,0,145,0,206,0,188,0,0,0,82,0,150,0,197,0,188,0,0,0,0,0,88,0,226,0,0,0,0,0,206,0,148,0,1,0,135,0,0,0,23,0,213,0,109,0,0,0,211,0,0,0,0,0,0,0,141,0,13,0,163,0,141,0,124,0,0,0,12,0,93,0,157,0,133,0,0,0,104,0,199,0,224,0,152,0,231,0,7,0,0,0,131,0,221,0,93,0,60,0,99,0,185,0,102,0,0,0,0,0,172,0,205,0,0,0,161,0,248,0,0,0,81,0,15,0,86,0,222,0,141,0,58,0,157,0,255,0,244,0,133,0,251,0,40,0,153,0,193,0,78,0,76,0,190,0,145,0,119,0,205,0,126,0,247,0,76,0,10,0,178,0,76,0,204,0,202,0,90,0,48,0,0,0,100,0,144,0,0,0,107,0,201,0,184,0,18,0,0,0,51,0,114,0,194,0,86,0,113,0,0,0,250,0,71,0,48,0,216,0,0,0,163,0,30,0,129,0,12,0,164,0,75,0,238,0,85,0,130,0,33,0,11,0,220,0,193,0,244,0,115,0,106,0,0,0,204,0,94,0,0,0,255,0,138,0,0,0,211,0,168,0,119,0,164,0,107,0,209,0,215,0,0,0,98,0,0,0,245,0,0,0,234,0,0,0,141,0,180,0,74,0,10,0,0,0,52,0,50,0,0,0,245,0,110,0,148,0,144,0,155,0,8,0,91,0,165,0,170,0,2,0,103,0,63,0,243,0,121,0,0,0,0,0,147,0,162,0,0,0,215,0,219,0,164,0,156,0,64,0,49,0,169,0,160,0,120,0,216,0,115,0,0,0,27,0,202,0,234,0,0,0,224,0,0,0,0,0,201,0,209,0,68,0,254,0,250,0,0,0,132,0,104,0,0,0,235,0,204,0,194,0,0,0,234,0,17,0,101,0,40,0,235,0,31,0,68,0,0,0);
signal scenario_full  : scenario_type := (0,0,77,31,173,31,195,31,209,31,243,31,14,31,163,31,3,31,10,31,10,30,234,31,200,31,35,31,35,30,58,31,58,30,134,31,134,30,199,31,215,31,191,31,17,31,198,31,198,30,225,31,160,31,160,30,252,31,180,31,65,31,65,30,65,29,74,31,232,31,232,30,47,31,220,31,220,30,191,31,191,30,191,29,191,28,172,31,31,31,206,31,9,31,129,31,65,31,65,30,155,31,194,31,218,31,153,31,20,31,99,31,99,30,99,31,182,31,223,31,163,31,163,30,176,31,53,31,74,31,74,30,85,31,86,31,34,31,34,30,253,31,253,30,253,29,156,31,117,31,117,30,179,31,179,30,179,29,202,31,206,31,28,31,47,31,109,31,109,30,197,31,197,30,207,31,66,31,223,31,17,31,152,31,104,31,104,30,207,31,154,31,129,31,118,31,42,31,42,30,115,31,233,31,245,31,14,31,162,31,159,31,93,31,33,31,33,30,33,29,236,31,96,31,51,31,151,31,151,30,151,29,121,31,97,31,97,30,241,31,33,31,2,31,2,30,2,29,59,31,98,31,185,31,161,31,64,31,200,31,206,31,141,31,197,31,192,31,192,30,24,31,24,30,185,31,122,31,146,31,146,30,61,31,19,31,28,31,75,31,216,31,216,30,216,29,87,31,218,31,211,31,236,31,42,31,42,30,161,31,161,30,253,31,157,31,128,31,85,31,85,30,206,31,178,31,158,31,199,31,21,31,21,30,21,29,220,31,73,31,165,31,126,31,161,31,161,30,116,31,240,31,72,31,237,31,142,31,165,31,42,31,111,31,36,31,36,30,34,31,34,30,120,31,120,30,123,31,203,31,237,31,68,31,15,31,170,31,125,31,60,31,7,31,64,31,123,31,123,30,213,31,213,30,11,31,227,31,151,31,151,30,54,31,54,30,39,31,183,31,183,30,179,31,198,31,198,30,210,31,227,31,227,30,142,31,44,31,67,31,67,30,185,31,208,31,141,31,62,31,44,31,91,31,77,31,251,31,224,31,173,31,170,31,75,31,237,31,115,31,115,30,146,31,96,31,96,30,162,31,184,31,235,31,235,30,65,31,51,31,156,31,156,30,96,31,191,31,245,31,245,30,238,31,18,31,28,31,151,31,160,31,50,31,44,31,240,31,163,31,183,31,183,30,200,31,92,31,163,31,229,31,112,31,245,31,245,30,94,31,167,31,47,31,171,31,185,31,236,31,236,30,212,31,188,31,98,31,89,31,220,31,251,31,120,31,135,31,90,31,167,31,17,31,39,31,104,31,104,30,79,31,50,31,104,31,208,31,140,31,83,31,7,31,203,31,203,30,255,31,64,31,64,30,163,31,11,31,112,31,130,31,214,31,57,31,246,31,49,31,145,31,44,31,23,31,253,31,238,31,113,31,113,30,35,31,196,31,196,30,247,31,214,31,180,31,211,31,249,31,155,31,27,31,123,31,86,31,135,31,135,30,84,31,97,31,97,30,58,31,58,30,58,29,160,31,228,31,228,30,137,31,240,31,233,31,57,31,155,31,101,31,120,31,208,31,64,31,44,31,195,31,105,31,71,31,18,31,221,31,77,31,140,31,129,31,129,30,11,31,27,31,146,31,248,31,248,30,251,31,36,31,202,31,250,31,132,31,72,31,2,31,22,31,114,31,117,31,234,31,234,30,208,31,51,31,111,31,185,31,185,31,205,31,205,30,205,29,12,31,181,31,216,31,176,31,159,31,163,31,231,31,131,31,157,31,219,31,74,31,91,31,7,31,208,31,163,31,163,30,221,31,65,31,144,31,241,31,27,31,27,30,27,29,238,31,224,31,81,31,29,31,47,31,47,30,11,31,148,31,29,31,189,31,62,31,193,31,130,31,129,31,34,31,34,30,206,31,206,30,34,31,188,31,188,30,188,29,56,31,183,31,169,31,116,31,116,30,20,31,205,31,122,31,207,31,207,30,207,29,207,28,122,31,147,31,226,31,176,31,209,31,120,31,223,31,93,31,93,30,77,31,105,31,168,31,147,31,86,31,119,31,85,31,174,31,174,30,111,31,111,30,111,29,197,31,164,31,162,31,157,31,162,31,79,31,137,31,121,31,189,31,203,31,203,30,29,31,225,31,53,31,170,31,153,31,127,31,201,31,147,31,147,31,147,30,226,31,97,31,93,31,72,31,140,31,45,31,138,31,149,31,176,31,64,31,112,31,66,31,248,31,107,31,107,31,32,31,32,30,120,31,120,30,252,31,156,31,11,31,11,30,121,31,63,31,169,31,219,31,146,31,26,31,119,31,148,31,186,31,104,31,180,31,40,31,225,31,225,30,32,31,223,31,168,31,180,31,107,31,190,31,246,31,225,31,11,31,92,31,26,31,120,31,40,31,40,30,40,29,37,31,230,31,44,31,53,31,166,31,3,31,110,31,84,31,63,31,16,31,180,31,28,31,66,31,204,31,238,31,201,31,232,31,64,31,224,31,147,31,147,30,6,31,233,31,215,31,232,31,57,31,57,30,203,31,66,31,222,31,127,31,156,31,156,30,144,31,144,30,170,31,11,31,11,30,164,31,135,31,135,30,135,29,193,31,218,31,140,31,140,30,243,31,59,31,59,30,153,31,113,31,156,31,41,31,46,31,138,31,242,31,218,31,168,31,183,31,183,30,169,31,218,31,127,31,224,31,13,31,13,30,135,31,53,31,217,31,50,31,94,31,137,31,6,31,22,31,1,31,1,30,202,31,253,31,63,31,250,31,142,31,174,31,174,30,138,31,129,31,166,31,115,31,205,31,54,31,54,31,193,31,61,31,14,31,134,31,147,31,147,30,147,29,107,31,147,31,149,31,149,30,237,31,158,31,28,31,156,31,12,31,12,30,248,31,201,31,201,30,31,31,145,31,206,31,188,31,188,30,82,31,150,31,197,31,188,31,188,30,188,29,88,31,226,31,226,30,226,29,206,31,148,31,1,31,135,31,135,30,23,31,213,31,109,31,109,30,211,31,211,30,211,29,211,28,141,31,13,31,163,31,141,31,124,31,124,30,12,31,93,31,157,31,133,31,133,30,104,31,199,31,224,31,152,31,231,31,7,31,7,30,131,31,221,31,93,31,60,31,99,31,185,31,102,31,102,30,102,29,172,31,205,31,205,30,161,31,248,31,248,30,81,31,15,31,86,31,222,31,141,31,58,31,157,31,255,31,244,31,133,31,251,31,40,31,153,31,193,31,78,31,76,31,190,31,145,31,119,31,205,31,126,31,247,31,76,31,10,31,178,31,76,31,204,31,202,31,90,31,48,31,48,30,100,31,144,31,144,30,107,31,201,31,184,31,18,31,18,30,51,31,114,31,194,31,86,31,113,31,113,30,250,31,71,31,48,31,216,31,216,30,163,31,30,31,129,31,12,31,164,31,75,31,238,31,85,31,130,31,33,31,11,31,220,31,193,31,244,31,115,31,106,31,106,30,204,31,94,31,94,30,255,31,138,31,138,30,211,31,168,31,119,31,164,31,107,31,209,31,215,31,215,30,98,31,98,30,245,31,245,30,234,31,234,30,141,31,180,31,74,31,10,31,10,30,52,31,50,31,50,30,245,31,110,31,148,31,144,31,155,31,8,31,91,31,165,31,170,31,2,31,103,31,63,31,243,31,121,31,121,30,121,29,147,31,162,31,162,30,215,31,219,31,164,31,156,31,64,31,49,31,169,31,160,31,120,31,216,31,115,31,115,30,27,31,202,31,234,31,234,30,224,31,224,30,224,29,201,31,209,31,68,31,254,31,250,31,250,30,132,31,104,31,104,30,235,31,204,31,194,31,194,30,234,31,17,31,101,31,40,31,235,31,31,31,68,31,68,30);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
