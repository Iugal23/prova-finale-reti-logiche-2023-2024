-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_314 is
end project_tb_314;

architecture project_tb_arch_314 of project_tb_314 is
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

constant SCENARIO_LENGTH : integer := 877;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (30,0,0,0,192,0,0,0,7,0,152,0,211,0,222,0,241,0,55,0,0,0,166,0,128,0,0,0,58,0,248,0,133,0,155,0,0,0,150,0,205,0,253,0,0,0,37,0,0,0,142,0,26,0,0,0,195,0,204,0,43,0,68,0,228,0,10,0,227,0,0,0,0,0,230,0,33,0,222,0,121,0,178,0,202,0,47,0,241,0,128,0,100,0,77,0,65,0,106,0,114,0,0,0,86,0,0,0,43,0,79,0,163,0,93,0,218,0,205,0,57,0,62,0,0,0,31,0,93,0,201,0,125,0,0,0,85,0,184,0,91,0,89,0,147,0,6,0,129,0,116,0,0,0,24,0,85,0,120,0,61,0,0,0,0,0,222,0,181,0,87,0,205,0,0,0,182,0,171,0,0,0,160,0,167,0,54,0,0,0,173,0,193,0,141,0,113,0,90,0,103,0,225,0,217,0,14,0,140,0,27,0,0,0,227,0,248,0,0,0,58,0,165,0,235,0,96,0,103,0,250,0,126,0,0,0,134,0,58,0,24,0,246,0,232,0,238,0,27,0,254,0,217,0,118,0,98,0,41,0,143,0,202,0,21,0,85,0,160,0,0,0,124,0,233,0,130,0,243,0,184,0,100,0,48,0,53,0,0,0,140,0,134,0,0,0,6,0,0,0,155,0,83,0,250,0,111,0,142,0,35,0,0,0,170,0,0,0,198,0,225,0,39,0,247,0,63,0,75,0,222,0,188,0,15,0,0,0,0,0,19,0,56,0,0,0,27,0,252,0,0,0,0,0,0,0,220,0,119,0,27,0,14,0,46,0,181,0,28,0,157,0,168,0,170,0,216,0,49,0,246,0,0,0,237,0,0,0,72,0,7,0,103,0,213,0,87,0,208,0,249,0,183,0,77,0,115,0,0,0,57,0,0,0,55,0,92,0,192,0,150,0,63,0,0,0,15,0,0,0,3,0,102,0,0,0,223,0,228,0,194,0,190,0,89,0,173,0,49,0,11,0,41,0,0,0,133,0,186,0,4,0,51,0,227,0,226,0,203,0,20,0,0,0,165,0,0,0,82,0,5,0,177,0,144,0,220,0,173,0,60,0,188,0,24,0,159,0,186,0,14,0,188,0,92,0,182,0,55,0,164,0,41,0,26,0,78,0,131,0,180,0,193,0,38,0,43,0,54,0,0,0,20,0,0,0,85,0,94,0,185,0,120,0,220,0,105,0,94,0,114,0,78,0,208,0,226,0,44,0,126,0,0,0,95,0,53,0,14,0,140,0,64,0,199,0,0,0,44,0,125,0,16,0,84,0,99,0,0,0,198,0,217,0,97,0,90,0,133,0,245,0,0,0,161,0,53,0,101,0,0,0,94,0,121,0,0,0,0,0,215,0,228,0,78,0,48,0,227,0,142,0,220,0,231,0,0,0,137,0,5,0,252,0,26,0,55,0,248,0,215,0,230,0,26,0,76,0,74,0,243,0,240,0,194,0,0,0,204,0,71,0,202,0,240,0,154,0,203,0,27,0,70,0,90,0,0,0,0,0,130,0,171,0,132,0,147,0,194,0,204,0,193,0,0,0,158,0,222,0,0,0,61,0,208,0,63,0,0,0,225,0,79,0,222,0,164,0,216,0,243,0,0,0,0,0,0,0,119,0,72,0,217,0,253,0,172,0,132,0,189,0,131,0,215,0,0,0,0,0,86,0,187,0,207,0,11,0,5,0,135,0,249,0,209,0,44,0,242,0,19,0,213,0,240,0,148,0,199,0,0,0,209,0,241,0,86,0,51,0,109,0,10,0,0,0,214,0,166,0,13,0,0,0,105,0,58,0,7,0,78,0,63,0,162,0,248,0,83,0,0,0,16,0,157,0,120,0,0,0,241,0,90,0,0,0,30,0,0,0,68,0,187,0,79,0,60,0,5,0,165,0,66,0,81,0,75,0,3,0,0,0,91,0,0,0,0,0,174,0,71,0,58,0,27,0,142,0,227,0,0,0,141,0,0,0,112,0,40,0,180,0,213,0,74,0,103,0,244,0,115,0,209,0,36,0,190,0,64,0,216,0,97,0,126,0,0,0,213,0,254,0,201,0,145,0,133,0,253,0,133,0,96,0,234,0,245,0,0,0,236,0,227,0,37,0,56,0,112,0,0,0,215,0,101,0,8,0,193,0,191,0,0,0,101,0,191,0,215,0,197,0,53,0,0,0,126,0,108,0,74,0,0,0,207,0,11,0,239,0,129,0,118,0,48,0,8,0,167,0,0,0,0,0,194,0,0,0,62,0,46,0,9,0,80,0,228,0,85,0,0,0,76,0,0,0,61,0,78,0,85,0,234,0,149,0,15,0,120,0,119,0,148,0,108,0,0,0,246,0,41,0,32,0,0,0,180,0,79,0,239,0,232,0,253,0,135,0,251,0,155,0,220,0,0,0,222,0,136,0,0,0,0,0,135,0,0,0,170,0,166,0,171,0,205,0,12,0,21,0,0,0,0,0,36,0,35,0,15,0,111,0,176,0,248,0,12,0,34,0,156,0,174,0,82,0,159,0,96,0,92,0,192,0,0,0,62,0,2,0,221,0,181,0,245,0,159,0,116,0,171,0,151,0,228,0,205,0,5,0,88,0,0,0,117,0,0,0,0,0,52,0,215,0,113,0,223,0,0,0,56,0,28,0,132,0,219,0,64,0,236,0,67,0,155,0,230,0,225,0,71,0,123,0,177,0,178,0,108,0,194,0,0,0,0,0,96,0,35,0,65,0,0,0,0,0,0,0,69,0,188,0,74,0,0,0,115,0,137,0,110,0,44,0,37,0,0,0,0,0,155,0,192,0,29,0,133,0,170,0,129,0,116,0,215,0,199,0,252,0,216,0,38,0,188,0,63,0,165,0,225,0,0,0,14,0,0,0,196,0,116,0,0,0,243,0,28,0,33,0,21,0,0,0,43,0,81,0,0,0,195,0,0,0,24,0,0,0,20,0,79,0,54,0,249,0,47,0,134,0,178,0,185,0,159,0,78,0,40,0,34,0,215,0,51,0,0,0,84,0,0,0,32,0,56,0,239,0,155,0,0,0,32,0,0,0,87,0,249,0,51,0,85,0,0,0,0,0,113,0,0,0,64,0,156,0,123,0,132,0,154,0,227,0,168,0,72,0,122,0,246,0,0,0,0,0,77,0,0,0,252,0,122,0,84,0,21,0,53,0,214,0,0,0,127,0,236,0,42,0,168,0,41,0,95,0,231,0,106,0,201,0,217,0,124,0,63,0,199,0,212,0,14,0,196,0,14,0,134,0,24,0,234,0,0,0,47,0,0,0,0,0,131,0,11,0,0,0,86,0,0,0,0,0,137,0,24,0,123,0,39,0,43,0,224,0,69,0,169,0,3,0,194,0,6,0,255,0,179,0,163,0,44,0,185,0,0,0,119,0,125,0,185,0,180,0,0,0,0,0,0,0,37,0,2,0,167,0,0,0,24,0,72,0,164,0,77,0,0,0,0,0,169,0,0,0,233,0,49,0,189,0,126,0,255,0,143,0,0,0,181,0,172,0,236,0,83,0,49,0,214,0,28,0,78,0,240,0,156,0,183,0,0,0,30,0,168,0,0,0,254,0,10,0,33,0,24,0,116,0,136,0,71,0,11,0,137,0,241,0,159,0,0,0,184,0,149,0,225,0,155,0,64,0,165,0,120,0,243,0,154,0,122,0,133,0,190,0,171,0,0,0,250,0,210,0,21,0,177,0,0,0,20,0,0,0,188,0,123,0,93,0,0,0,186,0,87,0,13,0,143,0,29,0,234,0,0,0,0,0,226,0,230,0,251,0,0,0,241,0,6,0,29,0,248,0,199,0,179,0,236,0,220,0,58,0,106,0,0,0,0,0,77,0,58,0,234,0,0,0,0,0,124,0,0,0,0,0,14,0,157,0,212,0);
signal scenario_full  : scenario_type := (30,31,30,30,192,31,192,30,7,31,152,31,211,31,222,31,241,31,55,31,55,30,166,31,128,31,128,30,58,31,248,31,133,31,155,31,155,30,150,31,205,31,253,31,253,30,37,31,37,30,142,31,26,31,26,30,195,31,204,31,43,31,68,31,228,31,10,31,227,31,227,30,227,29,230,31,33,31,222,31,121,31,178,31,202,31,47,31,241,31,128,31,100,31,77,31,65,31,106,31,114,31,114,30,86,31,86,30,43,31,79,31,163,31,93,31,218,31,205,31,57,31,62,31,62,30,31,31,93,31,201,31,125,31,125,30,85,31,184,31,91,31,89,31,147,31,6,31,129,31,116,31,116,30,24,31,85,31,120,31,61,31,61,30,61,29,222,31,181,31,87,31,205,31,205,30,182,31,171,31,171,30,160,31,167,31,54,31,54,30,173,31,193,31,141,31,113,31,90,31,103,31,225,31,217,31,14,31,140,31,27,31,27,30,227,31,248,31,248,30,58,31,165,31,235,31,96,31,103,31,250,31,126,31,126,30,134,31,58,31,24,31,246,31,232,31,238,31,27,31,254,31,217,31,118,31,98,31,41,31,143,31,202,31,21,31,85,31,160,31,160,30,124,31,233,31,130,31,243,31,184,31,100,31,48,31,53,31,53,30,140,31,134,31,134,30,6,31,6,30,155,31,83,31,250,31,111,31,142,31,35,31,35,30,170,31,170,30,198,31,225,31,39,31,247,31,63,31,75,31,222,31,188,31,15,31,15,30,15,29,19,31,56,31,56,30,27,31,252,31,252,30,252,29,252,28,220,31,119,31,27,31,14,31,46,31,181,31,28,31,157,31,168,31,170,31,216,31,49,31,246,31,246,30,237,31,237,30,72,31,7,31,103,31,213,31,87,31,208,31,249,31,183,31,77,31,115,31,115,30,57,31,57,30,55,31,92,31,192,31,150,31,63,31,63,30,15,31,15,30,3,31,102,31,102,30,223,31,228,31,194,31,190,31,89,31,173,31,49,31,11,31,41,31,41,30,133,31,186,31,4,31,51,31,227,31,226,31,203,31,20,31,20,30,165,31,165,30,82,31,5,31,177,31,144,31,220,31,173,31,60,31,188,31,24,31,159,31,186,31,14,31,188,31,92,31,182,31,55,31,164,31,41,31,26,31,78,31,131,31,180,31,193,31,38,31,43,31,54,31,54,30,20,31,20,30,85,31,94,31,185,31,120,31,220,31,105,31,94,31,114,31,78,31,208,31,226,31,44,31,126,31,126,30,95,31,53,31,14,31,140,31,64,31,199,31,199,30,44,31,125,31,16,31,84,31,99,31,99,30,198,31,217,31,97,31,90,31,133,31,245,31,245,30,161,31,53,31,101,31,101,30,94,31,121,31,121,30,121,29,215,31,228,31,78,31,48,31,227,31,142,31,220,31,231,31,231,30,137,31,5,31,252,31,26,31,55,31,248,31,215,31,230,31,26,31,76,31,74,31,243,31,240,31,194,31,194,30,204,31,71,31,202,31,240,31,154,31,203,31,27,31,70,31,90,31,90,30,90,29,130,31,171,31,132,31,147,31,194,31,204,31,193,31,193,30,158,31,222,31,222,30,61,31,208,31,63,31,63,30,225,31,79,31,222,31,164,31,216,31,243,31,243,30,243,29,243,28,119,31,72,31,217,31,253,31,172,31,132,31,189,31,131,31,215,31,215,30,215,29,86,31,187,31,207,31,11,31,5,31,135,31,249,31,209,31,44,31,242,31,19,31,213,31,240,31,148,31,199,31,199,30,209,31,241,31,86,31,51,31,109,31,10,31,10,30,214,31,166,31,13,31,13,30,105,31,58,31,7,31,78,31,63,31,162,31,248,31,83,31,83,30,16,31,157,31,120,31,120,30,241,31,90,31,90,30,30,31,30,30,68,31,187,31,79,31,60,31,5,31,165,31,66,31,81,31,75,31,3,31,3,30,91,31,91,30,91,29,174,31,71,31,58,31,27,31,142,31,227,31,227,30,141,31,141,30,112,31,40,31,180,31,213,31,74,31,103,31,244,31,115,31,209,31,36,31,190,31,64,31,216,31,97,31,126,31,126,30,213,31,254,31,201,31,145,31,133,31,253,31,133,31,96,31,234,31,245,31,245,30,236,31,227,31,37,31,56,31,112,31,112,30,215,31,101,31,8,31,193,31,191,31,191,30,101,31,191,31,215,31,197,31,53,31,53,30,126,31,108,31,74,31,74,30,207,31,11,31,239,31,129,31,118,31,48,31,8,31,167,31,167,30,167,29,194,31,194,30,62,31,46,31,9,31,80,31,228,31,85,31,85,30,76,31,76,30,61,31,78,31,85,31,234,31,149,31,15,31,120,31,119,31,148,31,108,31,108,30,246,31,41,31,32,31,32,30,180,31,79,31,239,31,232,31,253,31,135,31,251,31,155,31,220,31,220,30,222,31,136,31,136,30,136,29,135,31,135,30,170,31,166,31,171,31,205,31,12,31,21,31,21,30,21,29,36,31,35,31,15,31,111,31,176,31,248,31,12,31,34,31,156,31,174,31,82,31,159,31,96,31,92,31,192,31,192,30,62,31,2,31,221,31,181,31,245,31,159,31,116,31,171,31,151,31,228,31,205,31,5,31,88,31,88,30,117,31,117,30,117,29,52,31,215,31,113,31,223,31,223,30,56,31,28,31,132,31,219,31,64,31,236,31,67,31,155,31,230,31,225,31,71,31,123,31,177,31,178,31,108,31,194,31,194,30,194,29,96,31,35,31,65,31,65,30,65,29,65,28,69,31,188,31,74,31,74,30,115,31,137,31,110,31,44,31,37,31,37,30,37,29,155,31,192,31,29,31,133,31,170,31,129,31,116,31,215,31,199,31,252,31,216,31,38,31,188,31,63,31,165,31,225,31,225,30,14,31,14,30,196,31,116,31,116,30,243,31,28,31,33,31,21,31,21,30,43,31,81,31,81,30,195,31,195,30,24,31,24,30,20,31,79,31,54,31,249,31,47,31,134,31,178,31,185,31,159,31,78,31,40,31,34,31,215,31,51,31,51,30,84,31,84,30,32,31,56,31,239,31,155,31,155,30,32,31,32,30,87,31,249,31,51,31,85,31,85,30,85,29,113,31,113,30,64,31,156,31,123,31,132,31,154,31,227,31,168,31,72,31,122,31,246,31,246,30,246,29,77,31,77,30,252,31,122,31,84,31,21,31,53,31,214,31,214,30,127,31,236,31,42,31,168,31,41,31,95,31,231,31,106,31,201,31,217,31,124,31,63,31,199,31,212,31,14,31,196,31,14,31,134,31,24,31,234,31,234,30,47,31,47,30,47,29,131,31,11,31,11,30,86,31,86,30,86,29,137,31,24,31,123,31,39,31,43,31,224,31,69,31,169,31,3,31,194,31,6,31,255,31,179,31,163,31,44,31,185,31,185,30,119,31,125,31,185,31,180,31,180,30,180,29,180,28,37,31,2,31,167,31,167,30,24,31,72,31,164,31,77,31,77,30,77,29,169,31,169,30,233,31,49,31,189,31,126,31,255,31,143,31,143,30,181,31,172,31,236,31,83,31,49,31,214,31,28,31,78,31,240,31,156,31,183,31,183,30,30,31,168,31,168,30,254,31,10,31,33,31,24,31,116,31,136,31,71,31,11,31,137,31,241,31,159,31,159,30,184,31,149,31,225,31,155,31,64,31,165,31,120,31,243,31,154,31,122,31,133,31,190,31,171,31,171,30,250,31,210,31,21,31,177,31,177,30,20,31,20,30,188,31,123,31,93,31,93,30,186,31,87,31,13,31,143,31,29,31,234,31,234,30,234,29,226,31,230,31,251,31,251,30,241,31,6,31,29,31,248,31,199,31,179,31,236,31,220,31,58,31,106,31,106,30,106,29,77,31,58,31,234,31,234,30,234,29,124,31,124,30,124,29,14,31,157,31,212,31);

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
