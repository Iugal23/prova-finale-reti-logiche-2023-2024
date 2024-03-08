-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_916 is
end project_tb_916;

architecture project_tb_arch_916 of project_tb_916 is
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

constant SCENARIO_LENGTH : integer := 858;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (110,0,13,0,226,0,83,0,129,0,88,0,16,0,49,0,132,0,174,0,38,0,135,0,222,0,242,0,134,0,167,0,6,0,241,0,178,0,0,0,0,0,76,0,111,0,0,0,166,0,177,0,53,0,254,0,22,0,152,0,224,0,172,0,0,0,127,0,0,0,151,0,0,0,62,0,0,0,23,0,215,0,47,0,114,0,26,0,115,0,55,0,66,0,188,0,95,0,51,0,181,0,138,0,224,0,67,0,0,0,190,0,113,0,0,0,94,0,206,0,63,0,229,0,84,0,248,0,240,0,255,0,204,0,196,0,50,0,222,0,233,0,11,0,194,0,26,0,0,0,69,0,0,0,105,0,155,0,0,0,204,0,196,0,144,0,75,0,0,0,226,0,0,0,97,0,147,0,5,0,175,0,6,0,0,0,249,0,0,0,205,0,0,0,219,0,142,0,5,0,0,0,56,0,216,0,61,0,0,0,197,0,101,0,0,0,153,0,41,0,72,0,0,0,36,0,250,0,79,0,42,0,168,0,0,0,19,0,74,0,6,0,229,0,251,0,210,0,0,0,113,0,0,0,42,0,69,0,77,0,120,0,227,0,242,0,13,0,127,0,0,0,42,0,96,0,169,0,174,0,177,0,0,0,251,0,0,0,54,0,52,0,105,0,0,0,79,0,0,0,4,0,252,0,161,0,146,0,236,0,240,0,31,0,163,0,203,0,128,0,161,0,43,0,254,0,186,0,26,0,49,0,0,0,191,0,22,0,78,0,11,0,180,0,0,0,164,0,205,0,240,0,193,0,186,0,243,0,16,0,0,0,3,0,116,0,0,0,86,0,75,0,0,0,97,0,78,0,0,0,153,0,0,0,212,0,214,0,40,0,161,0,164,0,252,0,245,0,208,0,167,0,143,0,0,0,21,0,100,0,184,0,0,0,75,0,217,0,0,0,6,0,166,0,1,0,0,0,5,0,169,0,234,0,0,0,0,0,0,0,216,0,255,0,39,0,103,0,109,0,72,0,0,0,155,0,64,0,218,0,145,0,127,0,75,0,86,0,110,0,223,0,253,0,237,0,86,0,0,0,2,0,0,0,215,0,212,0,208,0,86,0,75,0,194,0,0,0,33,0,233,0,254,0,178,0,121,0,0,0,64,0,211,0,68,0,0,0,125,0,23,0,63,0,0,0,0,0,0,0,176,0,234,0,187,0,71,0,102,0,59,0,11,0,104,0,17,0,169,0,247,0,241,0,16,0,0,0,0,0,151,0,54,0,219,0,155,0,120,0,1,0,73,0,219,0,231,0,0,0,0,0,136,0,191,0,35,0,193,0,125,0,44,0,0,0,163,0,100,0,5,0,201,0,220,0,237,0,0,0,0,0,0,0,228,0,64,0,118,0,46,0,74,0,0,0,75,0,254,0,97,0,231,0,250,0,126,0,25,0,58,0,222,0,155,0,122,0,182,0,161,0,192,0,211,0,133,0,124,0,252,0,170,0,125,0,47,0,101,0,222,0,113,0,85,0,156,0,20,0,70,0,0,0,0,0,145,0,134,0,25,0,165,0,0,0,224,0,211,0,233,0,24,0,202,0,129,0,83,0,197,0,31,0,185,0,89,0,51,0,182,0,3,0,106,0,95,0,168,0,62,0,103,0,102,0,0,0,0,0,152,0,75,0,176,0,182,0,30,0,209,0,79,0,113,0,143,0,6,0,162,0,56,0,57,0,35,0,181,0,101,0,10,0,225,0,31,0,0,0,0,0,149,0,118,0,193,0,192,0,0,0,71,0,203,0,196,0,0,0,197,0,0,0,71,0,228,0,98,0,207,0,92,0,248,0,0,0,198,0,0,0,0,0,92,0,109,0,0,0,60,0,139,0,91,0,0,0,251,0,197,0,104,0,0,0,76,0,254,0,65,0,101,0,136,0,50,0,189,0,214,0,180,0,0,0,0,0,0,0,225,0,114,0,107,0,44,0,244,0,65,0,32,0,0,0,0,0,43,0,129,0,146,0,96,0,160,0,129,0,0,0,0,0,220,0,105,0,3,0,254,0,0,0,124,0,95,0,212,0,0,0,4,0,0,0,18,0,44,0,188,0,46,0,134,0,164,0,252,0,152,0,101,0,107,0,112,0,72,0,0,0,0,0,250,0,0,0,11,0,57,0,0,0,104,0,0,0,161,0,194,0,244,0,0,0,252,0,252,0,0,0,159,0,243,0,0,0,252,0,214,0,69,0,0,0,176,0,216,0,105,0,140,0,0,0,122,0,239,0,0,0,44,0,0,0,68,0,5,0,191,0,76,0,24,0,160,0,57,0,166,0,229,0,0,0,0,0,93,0,153,0,55,0,178,0,131,0,214,0,113,0,216,0,114,0,90,0,169,0,122,0,72,0,0,0,0,0,27,0,232,0,220,0,131,0,195,0,19,0,208,0,235,0,0,0,49,0,0,0,67,0,86,0,239,0,0,0,112,0,243,0,50,0,0,0,6,0,92,0,0,0,79,0,57,0,107,0,0,0,91,0,81,0,200,0,173,0,134,0,213,0,224,0,24,0,140,0,132,0,141,0,17,0,0,0,0,0,198,0,21,0,205,0,0,0,234,0,250,0,19,0,0,0,225,0,96,0,3,0,59,0,166,0,0,0,77,0,182,0,111,0,98,0,214,0,0,0,189,0,224,0,0,0,0,0,0,0,249,0,117,0,182,0,127,0,194,0,239,0,119,0,250,0,137,0,57,0,55,0,0,0,0,0,0,0,33,0,35,0,205,0,20,0,212,0,0,0,153,0,181,0,175,0,143,0,247,0,56,0,115,0,52,0,172,0,248,0,163,0,0,0,105,0,131,0,176,0,243,0,0,0,252,0,75,0,0,0,239,0,121,0,249,0,238,0,0,0,63,0,245,0,15,0,0,0,38,0,96,0,56,0,126,0,23,0,104,0,0,0,206,0,174,0,0,0,158,0,222,0,230,0,164,0,120,0,139,0,0,0,101,0,241,0,0,0,0,0,162,0,202,0,251,0,28,0,0,0,237,0,201,0,89,0,112,0,75,0,159,0,70,0,222,0,238,0,69,0,0,0,0,0,148,0,81,0,75,0,17,0,0,0,45,0,181,0,152,0,233,0,155,0,199,0,8,0,147,0,0,0,0,0,79,0,91,0,1,0,126,0,195,0,0,0,49,0,0,0,0,0,0,0,0,0,226,0,173,0,105,0,0,0,103,0,184,0,0,0,94,0,170,0,0,0,0,0,128,0,136,0,208,0,11,0,131,0,204,0,158,0,6,0,38,0,145,0,235,0,120,0,106,0,0,0,0,0,230,0,47,0,0,0,242,0,5,0,237,0,119,0,178,0,137,0,244,0,23,0,213,0,20,0,121,0,220,0,222,0,0,0,0,0,97,0,112,0,145,0,67,0,183,0,214,0,37,0,164,0,132,0,138,0,221,0,182,0,0,0,53,0,136,0,0,0,124,0,113,0,116,0,243,0,46,0,80,0,136,0,227,0,0,0,108,0,208,0,248,0,0,0,94,0,54,0,106,0,71,0,209,0,157,0,133,0,141,0,52,0,129,0,29,0,132,0,120,0,0,0,255,0,141,0,40,0,40,0,193,0,0,0,46,0,26,0,229,0,155,0,119,0,12,0,36,0,54,0,222,0,0,0,65,0,90,0,255,0,146,0,103,0,209,0,54,0,192,0,0,0,63,0,129,0,226,0,0,0,0,0,82,0,128,0,63,0,221,0,109,0,229,0,226,0,135,0,36,0,7,0,0,0,117,0,0,0,146,0,228,0,137,0,15,0,219,0,199,0,78,0,255,0,13,0,0,0,165,0,0,0,0,0,172,0,120,0,73,0);
signal scenario_full  : scenario_type := (110,31,13,31,226,31,83,31,129,31,88,31,16,31,49,31,132,31,174,31,38,31,135,31,222,31,242,31,134,31,167,31,6,31,241,31,178,31,178,30,178,29,76,31,111,31,111,30,166,31,177,31,53,31,254,31,22,31,152,31,224,31,172,31,172,30,127,31,127,30,151,31,151,30,62,31,62,30,23,31,215,31,47,31,114,31,26,31,115,31,55,31,66,31,188,31,95,31,51,31,181,31,138,31,224,31,67,31,67,30,190,31,113,31,113,30,94,31,206,31,63,31,229,31,84,31,248,31,240,31,255,31,204,31,196,31,50,31,222,31,233,31,11,31,194,31,26,31,26,30,69,31,69,30,105,31,155,31,155,30,204,31,196,31,144,31,75,31,75,30,226,31,226,30,97,31,147,31,5,31,175,31,6,31,6,30,249,31,249,30,205,31,205,30,219,31,142,31,5,31,5,30,56,31,216,31,61,31,61,30,197,31,101,31,101,30,153,31,41,31,72,31,72,30,36,31,250,31,79,31,42,31,168,31,168,30,19,31,74,31,6,31,229,31,251,31,210,31,210,30,113,31,113,30,42,31,69,31,77,31,120,31,227,31,242,31,13,31,127,31,127,30,42,31,96,31,169,31,174,31,177,31,177,30,251,31,251,30,54,31,52,31,105,31,105,30,79,31,79,30,4,31,252,31,161,31,146,31,236,31,240,31,31,31,163,31,203,31,128,31,161,31,43,31,254,31,186,31,26,31,49,31,49,30,191,31,22,31,78,31,11,31,180,31,180,30,164,31,205,31,240,31,193,31,186,31,243,31,16,31,16,30,3,31,116,31,116,30,86,31,75,31,75,30,97,31,78,31,78,30,153,31,153,30,212,31,214,31,40,31,161,31,164,31,252,31,245,31,208,31,167,31,143,31,143,30,21,31,100,31,184,31,184,30,75,31,217,31,217,30,6,31,166,31,1,31,1,30,5,31,169,31,234,31,234,30,234,29,234,28,216,31,255,31,39,31,103,31,109,31,72,31,72,30,155,31,64,31,218,31,145,31,127,31,75,31,86,31,110,31,223,31,253,31,237,31,86,31,86,30,2,31,2,30,215,31,212,31,208,31,86,31,75,31,194,31,194,30,33,31,233,31,254,31,178,31,121,31,121,30,64,31,211,31,68,31,68,30,125,31,23,31,63,31,63,30,63,29,63,28,176,31,234,31,187,31,71,31,102,31,59,31,11,31,104,31,17,31,169,31,247,31,241,31,16,31,16,30,16,29,151,31,54,31,219,31,155,31,120,31,1,31,73,31,219,31,231,31,231,30,231,29,136,31,191,31,35,31,193,31,125,31,44,31,44,30,163,31,100,31,5,31,201,31,220,31,237,31,237,30,237,29,237,28,228,31,64,31,118,31,46,31,74,31,74,30,75,31,254,31,97,31,231,31,250,31,126,31,25,31,58,31,222,31,155,31,122,31,182,31,161,31,192,31,211,31,133,31,124,31,252,31,170,31,125,31,47,31,101,31,222,31,113,31,85,31,156,31,20,31,70,31,70,30,70,29,145,31,134,31,25,31,165,31,165,30,224,31,211,31,233,31,24,31,202,31,129,31,83,31,197,31,31,31,185,31,89,31,51,31,182,31,3,31,106,31,95,31,168,31,62,31,103,31,102,31,102,30,102,29,152,31,75,31,176,31,182,31,30,31,209,31,79,31,113,31,143,31,6,31,162,31,56,31,57,31,35,31,181,31,101,31,10,31,225,31,31,31,31,30,31,29,149,31,118,31,193,31,192,31,192,30,71,31,203,31,196,31,196,30,197,31,197,30,71,31,228,31,98,31,207,31,92,31,248,31,248,30,198,31,198,30,198,29,92,31,109,31,109,30,60,31,139,31,91,31,91,30,251,31,197,31,104,31,104,30,76,31,254,31,65,31,101,31,136,31,50,31,189,31,214,31,180,31,180,30,180,29,180,28,225,31,114,31,107,31,44,31,244,31,65,31,32,31,32,30,32,29,43,31,129,31,146,31,96,31,160,31,129,31,129,30,129,29,220,31,105,31,3,31,254,31,254,30,124,31,95,31,212,31,212,30,4,31,4,30,18,31,44,31,188,31,46,31,134,31,164,31,252,31,152,31,101,31,107,31,112,31,72,31,72,30,72,29,250,31,250,30,11,31,57,31,57,30,104,31,104,30,161,31,194,31,244,31,244,30,252,31,252,31,252,30,159,31,243,31,243,30,252,31,214,31,69,31,69,30,176,31,216,31,105,31,140,31,140,30,122,31,239,31,239,30,44,31,44,30,68,31,5,31,191,31,76,31,24,31,160,31,57,31,166,31,229,31,229,30,229,29,93,31,153,31,55,31,178,31,131,31,214,31,113,31,216,31,114,31,90,31,169,31,122,31,72,31,72,30,72,29,27,31,232,31,220,31,131,31,195,31,19,31,208,31,235,31,235,30,49,31,49,30,67,31,86,31,239,31,239,30,112,31,243,31,50,31,50,30,6,31,92,31,92,30,79,31,57,31,107,31,107,30,91,31,81,31,200,31,173,31,134,31,213,31,224,31,24,31,140,31,132,31,141,31,17,31,17,30,17,29,198,31,21,31,205,31,205,30,234,31,250,31,19,31,19,30,225,31,96,31,3,31,59,31,166,31,166,30,77,31,182,31,111,31,98,31,214,31,214,30,189,31,224,31,224,30,224,29,224,28,249,31,117,31,182,31,127,31,194,31,239,31,119,31,250,31,137,31,57,31,55,31,55,30,55,29,55,28,33,31,35,31,205,31,20,31,212,31,212,30,153,31,181,31,175,31,143,31,247,31,56,31,115,31,52,31,172,31,248,31,163,31,163,30,105,31,131,31,176,31,243,31,243,30,252,31,75,31,75,30,239,31,121,31,249,31,238,31,238,30,63,31,245,31,15,31,15,30,38,31,96,31,56,31,126,31,23,31,104,31,104,30,206,31,174,31,174,30,158,31,222,31,230,31,164,31,120,31,139,31,139,30,101,31,241,31,241,30,241,29,162,31,202,31,251,31,28,31,28,30,237,31,201,31,89,31,112,31,75,31,159,31,70,31,222,31,238,31,69,31,69,30,69,29,148,31,81,31,75,31,17,31,17,30,45,31,181,31,152,31,233,31,155,31,199,31,8,31,147,31,147,30,147,29,79,31,91,31,1,31,126,31,195,31,195,30,49,31,49,30,49,29,49,28,49,27,226,31,173,31,105,31,105,30,103,31,184,31,184,30,94,31,170,31,170,30,170,29,128,31,136,31,208,31,11,31,131,31,204,31,158,31,6,31,38,31,145,31,235,31,120,31,106,31,106,30,106,29,230,31,47,31,47,30,242,31,5,31,237,31,119,31,178,31,137,31,244,31,23,31,213,31,20,31,121,31,220,31,222,31,222,30,222,29,97,31,112,31,145,31,67,31,183,31,214,31,37,31,164,31,132,31,138,31,221,31,182,31,182,30,53,31,136,31,136,30,124,31,113,31,116,31,243,31,46,31,80,31,136,31,227,31,227,30,108,31,208,31,248,31,248,30,94,31,54,31,106,31,71,31,209,31,157,31,133,31,141,31,52,31,129,31,29,31,132,31,120,31,120,30,255,31,141,31,40,31,40,31,193,31,193,30,46,31,26,31,229,31,155,31,119,31,12,31,36,31,54,31,222,31,222,30,65,31,90,31,255,31,146,31,103,31,209,31,54,31,192,31,192,30,63,31,129,31,226,31,226,30,226,29,82,31,128,31,63,31,221,31,109,31,229,31,226,31,135,31,36,31,7,31,7,30,117,31,117,30,146,31,228,31,137,31,15,31,219,31,199,31,78,31,255,31,13,31,13,30,165,31,165,30,165,29,172,31,120,31,73,31);

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
