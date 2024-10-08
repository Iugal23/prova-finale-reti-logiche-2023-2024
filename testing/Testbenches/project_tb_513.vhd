-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_513 is
end project_tb_513;

architecture project_tb_arch_513 of project_tb_513 is
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

constant SCENARIO_LENGTH : integer := 862;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (27,0,0,0,64,0,186,0,0,0,7,0,177,0,165,0,166,0,82,0,76,0,161,0,152,0,0,0,21,0,242,0,99,0,157,0,199,0,0,0,0,0,229,0,177,0,0,0,143,0,225,0,44,0,90,0,41,0,55,0,0,0,139,0,0,0,99,0,141,0,0,0,232,0,234,0,0,0,100,0,118,0,0,0,81,0,63,0,232,0,238,0,30,0,82,0,0,0,0,0,197,0,0,0,210,0,223,0,144,0,92,0,249,0,0,0,95,0,69,0,0,0,130,0,216,0,144,0,50,0,236,0,182,0,78,0,46,0,0,0,0,0,0,0,0,0,125,0,0,0,52,0,167,0,200,0,42,0,0,0,0,0,63,0,0,0,244,0,159,0,148,0,56,0,54,0,198,0,220,0,141,0,0,0,0,0,230,0,0,0,19,0,146,0,11,0,111,0,16,0,224,0,254,0,130,0,51,0,204,0,6,0,216,0,144,0,0,0,141,0,101,0,88,0,13,0,0,0,98,0,0,0,129,0,82,0,130,0,145,0,131,0,91,0,0,0,25,0,102,0,178,0,3,0,130,0,24,0,153,0,179,0,26,0,135,0,0,0,203,0,226,0,95,0,110,0,200,0,73,0,102,0,237,0,0,0,94,0,0,0,0,0,53,0,189,0,0,0,64,0,0,0,138,0,60,0,194,0,47,0,0,0,133,0,196,0,0,0,173,0,50,0,118,0,71,0,34,0,66,0,241,0,157,0,38,0,41,0,229,0,175,0,0,0,127,0,0,0,0,0,222,0,57,0,200,0,37,0,0,0,127,0,102,0,137,0,103,0,248,0,137,0,136,0,241,0,179,0,76,0,32,0,57,0,93,0,20,0,0,0,0,0,39,0,0,0,217,0,22,0,31,0,72,0,108,0,173,0,0,0,202,0,111,0,106,0,100,0,80,0,168,0,72,0,41,0,22,0,86,0,166,0,0,0,72,0,0,0,143,0,159,0,126,0,205,0,197,0,154,0,25,0,41,0,152,0,199,0,0,0,105,0,0,0,29,0,84,0,204,0,126,0,0,0,42,0,179,0,107,0,241,0,103,0,89,0,209,0,211,0,144,0,6,0,98,0,169,0,42,0,191,0,218,0,0,0,143,0,0,0,102,0,48,0,225,0,84,0,0,0,0,0,0,0,31,0,0,0,149,0,170,0,11,0,129,0,91,0,163,0,207,0,199,0,0,0,162,0,64,0,111,0,0,0,231,0,75,0,87,0,0,0,78,0,0,0,0,0,0,0,0,0,221,0,224,0,169,0,3,0,88,0,0,0,172,0,0,0,62,0,43,0,122,0,203,0,92,0,122,0,185,0,0,0,241,0,0,0,145,0,63,0,0,0,77,0,233,0,221,0,154,0,250,0,62,0,0,0,198,0,94,0,86,0,240,0,149,0,129,0,0,0,63,0,47,0,48,0,0,0,229,0,227,0,144,0,207,0,62,0,0,0,15,0,200,0,60,0,0,0,5,0,72,0,10,0,30,0,236,0,200,0,148,0,0,0,26,0,106,0,125,0,120,0,58,0,9,0,37,0,122,0,38,0,186,0,19,0,174,0,22,0,150,0,41,0,221,0,223,0,171,0,125,0,246,0,18,0,116,0,0,0,227,0,176,0,39,0,0,0,192,0,0,0,11,0,246,0,15,0,23,0,200,0,191,0,242,0,216,0,254,0,0,0,92,0,26,0,0,0,228,0,246,0,188,0,96,0,180,0,62,0,161,0,231,0,188,0,137,0,96,0,67,0,200,0,145,0,0,0,238,0,6,0,83,0,55,0,77,0,106,0,0,0,192,0,0,0,88,0,214,0,99,0,190,0,70,0,165,0,174,0,254,0,232,0,208,0,68,0,0,0,0,0,0,0,75,0,57,0,216,0,106,0,8,0,0,0,203,0,173,0,78,0,15,0,142,0,151,0,252,0,166,0,172,0,169,0,84,0,30,0,239,0,136,0,185,0,56,0,91,0,6,0,79,0,94,0,200,0,84,0,28,0,228,0,117,0,200,0,194,0,174,0,40,0,0,0,85,0,0,0,160,0,70,0,0,0,0,0,25,0,17,0,6,0,23,0,0,0,173,0,157,0,151,0,178,0,215,0,167,0,80,0,17,0,199,0,98,0,135,0,82,0,0,0,40,0,3,0,69,0,100,0,177,0,140,0,155,0,119,0,245,0,0,0,0,0,98,0,187,0,0,0,136,0,0,0,116,0,182,0,57,0,0,0,151,0,47,0,0,0,32,0,56,0,0,0,109,0,62,0,195,0,89,0,51,0,68,0,4,0,231,0,0,0,183,0,58,0,225,0,0,0,5,0,40,0,159,0,97,0,99,0,193,0,202,0,132,0,25,0,136,0,0,0,51,0,168,0,0,0,203,0,48,0,253,0,33,0,10,0,133,0,22,0,0,0,208,0,143,0,0,0,163,0,0,0,37,0,24,0,238,0,23,0,37,0,201,0,0,0,0,0,141,0,130,0,79,0,97,0,0,0,0,0,221,0,125,0,119,0,0,0,47,0,238,0,66,0,74,0,175,0,91,0,92,0,9,0,86,0,118,0,0,0,123,0,92,0,176,0,207,0,214,0,200,0,95,0,68,0,181,0,246,0,0,0,73,0,102,0,90,0,190,0,198,0,0,0,70,0,0,0,81,0,17,0,114,0,0,0,188,0,3,0,193,0,235,0,216,0,43,0,17,0,14,0,0,0,186,0,166,0,43,0,254,0,163,0,181,0,81,0,76,0,203,0,239,0,27,0,124,0,82,0,86,0,72,0,92,0,182,0,0,0,111,0,0,0,0,0,179,0,172,0,145,0,7,0,71,0,237,0,0,0,139,0,67,0,225,0,94,0,235,0,28,0,43,0,0,0,210,0,190,0,119,0,0,0,120,0,254,0,90,0,0,0,170,0,100,0,56,0,168,0,0,0,27,0,36,0,104,0,0,0,0,0,37,0,0,0,215,0,49,0,191,0,21,0,0,0,33,0,236,0,0,0,0,0,9,0,210,0,173,0,44,0,229,0,0,0,172,0,214,0,131,0,223,0,55,0,0,0,9,0,84,0,9,0,241,0,35,0,99,0,115,0,185,0,48,0,0,0,198,0,246,0,0,0,203,0,74,0,82,0,163,0,140,0,183,0,0,0,37,0,72,0,216,0,10,0,1,0,102,0,0,0,0,0,0,0,248,0,252,0,201,0,221,0,169,0,188,0,254,0,0,0,72,0,220,0,188,0,218,0,0,0,210,0,197,0,0,0,0,0,162,0,30,0,182,0,0,0,127,0,0,0,175,0,241,0,239,0,0,0,255,0,187,0,136,0,0,0,38,0,83,0,76,0,53,0,15,0,184,0,247,0,81,0,238,0,230,0,149,0,227,0,69,0,238,0,32,0,181,0,83,0,232,0,0,0,130,0,7,0,31,0,166,0,0,0,234,0,106,0,255,0,95,0,177,0,219,0,250,0,6,0,123,0,0,0,149,0,52,0,143,0,0,0,0,0,231,0,197,0,0,0,0,0,52,0,14,0,122,0,246,0,193,0,0,0,248,0,206,0,0,0,117,0,233,0,136,0,0,0,4,0,127,0,36,0,131,0,107,0,150,0,123,0,99,0,244,0,0,0,194,0,50,0,253,0,130,0,189,0,170,0,234,0,176,0,0,0,219,0,191,0,95,0,40,0,150,0,204,0,203,0,252,0,153,0,0,0,0,0,0,0,85,0,144,0,20,0,154,0,61,0,1,0,0,0,177,0,130,0,146,0,120,0,0,0,161,0,0,0,49,0,0,0,111,0,220,0,64,0,0,0,0,0,195,0,0,0,78,0,194,0,182,0,206,0,165,0);
signal scenario_full  : scenario_type := (27,31,27,30,64,31,186,31,186,30,7,31,177,31,165,31,166,31,82,31,76,31,161,31,152,31,152,30,21,31,242,31,99,31,157,31,199,31,199,30,199,29,229,31,177,31,177,30,143,31,225,31,44,31,90,31,41,31,55,31,55,30,139,31,139,30,99,31,141,31,141,30,232,31,234,31,234,30,100,31,118,31,118,30,81,31,63,31,232,31,238,31,30,31,82,31,82,30,82,29,197,31,197,30,210,31,223,31,144,31,92,31,249,31,249,30,95,31,69,31,69,30,130,31,216,31,144,31,50,31,236,31,182,31,78,31,46,31,46,30,46,29,46,28,46,27,125,31,125,30,52,31,167,31,200,31,42,31,42,30,42,29,63,31,63,30,244,31,159,31,148,31,56,31,54,31,198,31,220,31,141,31,141,30,141,29,230,31,230,30,19,31,146,31,11,31,111,31,16,31,224,31,254,31,130,31,51,31,204,31,6,31,216,31,144,31,144,30,141,31,101,31,88,31,13,31,13,30,98,31,98,30,129,31,82,31,130,31,145,31,131,31,91,31,91,30,25,31,102,31,178,31,3,31,130,31,24,31,153,31,179,31,26,31,135,31,135,30,203,31,226,31,95,31,110,31,200,31,73,31,102,31,237,31,237,30,94,31,94,30,94,29,53,31,189,31,189,30,64,31,64,30,138,31,60,31,194,31,47,31,47,30,133,31,196,31,196,30,173,31,50,31,118,31,71,31,34,31,66,31,241,31,157,31,38,31,41,31,229,31,175,31,175,30,127,31,127,30,127,29,222,31,57,31,200,31,37,31,37,30,127,31,102,31,137,31,103,31,248,31,137,31,136,31,241,31,179,31,76,31,32,31,57,31,93,31,20,31,20,30,20,29,39,31,39,30,217,31,22,31,31,31,72,31,108,31,173,31,173,30,202,31,111,31,106,31,100,31,80,31,168,31,72,31,41,31,22,31,86,31,166,31,166,30,72,31,72,30,143,31,159,31,126,31,205,31,197,31,154,31,25,31,41,31,152,31,199,31,199,30,105,31,105,30,29,31,84,31,204,31,126,31,126,30,42,31,179,31,107,31,241,31,103,31,89,31,209,31,211,31,144,31,6,31,98,31,169,31,42,31,191,31,218,31,218,30,143,31,143,30,102,31,48,31,225,31,84,31,84,30,84,29,84,28,31,31,31,30,149,31,170,31,11,31,129,31,91,31,163,31,207,31,199,31,199,30,162,31,64,31,111,31,111,30,231,31,75,31,87,31,87,30,78,31,78,30,78,29,78,28,78,27,221,31,224,31,169,31,3,31,88,31,88,30,172,31,172,30,62,31,43,31,122,31,203,31,92,31,122,31,185,31,185,30,241,31,241,30,145,31,63,31,63,30,77,31,233,31,221,31,154,31,250,31,62,31,62,30,198,31,94,31,86,31,240,31,149,31,129,31,129,30,63,31,47,31,48,31,48,30,229,31,227,31,144,31,207,31,62,31,62,30,15,31,200,31,60,31,60,30,5,31,72,31,10,31,30,31,236,31,200,31,148,31,148,30,26,31,106,31,125,31,120,31,58,31,9,31,37,31,122,31,38,31,186,31,19,31,174,31,22,31,150,31,41,31,221,31,223,31,171,31,125,31,246,31,18,31,116,31,116,30,227,31,176,31,39,31,39,30,192,31,192,30,11,31,246,31,15,31,23,31,200,31,191,31,242,31,216,31,254,31,254,30,92,31,26,31,26,30,228,31,246,31,188,31,96,31,180,31,62,31,161,31,231,31,188,31,137,31,96,31,67,31,200,31,145,31,145,30,238,31,6,31,83,31,55,31,77,31,106,31,106,30,192,31,192,30,88,31,214,31,99,31,190,31,70,31,165,31,174,31,254,31,232,31,208,31,68,31,68,30,68,29,68,28,75,31,57,31,216,31,106,31,8,31,8,30,203,31,173,31,78,31,15,31,142,31,151,31,252,31,166,31,172,31,169,31,84,31,30,31,239,31,136,31,185,31,56,31,91,31,6,31,79,31,94,31,200,31,84,31,28,31,228,31,117,31,200,31,194,31,174,31,40,31,40,30,85,31,85,30,160,31,70,31,70,30,70,29,25,31,17,31,6,31,23,31,23,30,173,31,157,31,151,31,178,31,215,31,167,31,80,31,17,31,199,31,98,31,135,31,82,31,82,30,40,31,3,31,69,31,100,31,177,31,140,31,155,31,119,31,245,31,245,30,245,29,98,31,187,31,187,30,136,31,136,30,116,31,182,31,57,31,57,30,151,31,47,31,47,30,32,31,56,31,56,30,109,31,62,31,195,31,89,31,51,31,68,31,4,31,231,31,231,30,183,31,58,31,225,31,225,30,5,31,40,31,159,31,97,31,99,31,193,31,202,31,132,31,25,31,136,31,136,30,51,31,168,31,168,30,203,31,48,31,253,31,33,31,10,31,133,31,22,31,22,30,208,31,143,31,143,30,163,31,163,30,37,31,24,31,238,31,23,31,37,31,201,31,201,30,201,29,141,31,130,31,79,31,97,31,97,30,97,29,221,31,125,31,119,31,119,30,47,31,238,31,66,31,74,31,175,31,91,31,92,31,9,31,86,31,118,31,118,30,123,31,92,31,176,31,207,31,214,31,200,31,95,31,68,31,181,31,246,31,246,30,73,31,102,31,90,31,190,31,198,31,198,30,70,31,70,30,81,31,17,31,114,31,114,30,188,31,3,31,193,31,235,31,216,31,43,31,17,31,14,31,14,30,186,31,166,31,43,31,254,31,163,31,181,31,81,31,76,31,203,31,239,31,27,31,124,31,82,31,86,31,72,31,92,31,182,31,182,30,111,31,111,30,111,29,179,31,172,31,145,31,7,31,71,31,237,31,237,30,139,31,67,31,225,31,94,31,235,31,28,31,43,31,43,30,210,31,190,31,119,31,119,30,120,31,254,31,90,31,90,30,170,31,100,31,56,31,168,31,168,30,27,31,36,31,104,31,104,30,104,29,37,31,37,30,215,31,49,31,191,31,21,31,21,30,33,31,236,31,236,30,236,29,9,31,210,31,173,31,44,31,229,31,229,30,172,31,214,31,131,31,223,31,55,31,55,30,9,31,84,31,9,31,241,31,35,31,99,31,115,31,185,31,48,31,48,30,198,31,246,31,246,30,203,31,74,31,82,31,163,31,140,31,183,31,183,30,37,31,72,31,216,31,10,31,1,31,102,31,102,30,102,29,102,28,248,31,252,31,201,31,221,31,169,31,188,31,254,31,254,30,72,31,220,31,188,31,218,31,218,30,210,31,197,31,197,30,197,29,162,31,30,31,182,31,182,30,127,31,127,30,175,31,241,31,239,31,239,30,255,31,187,31,136,31,136,30,38,31,83,31,76,31,53,31,15,31,184,31,247,31,81,31,238,31,230,31,149,31,227,31,69,31,238,31,32,31,181,31,83,31,232,31,232,30,130,31,7,31,31,31,166,31,166,30,234,31,106,31,255,31,95,31,177,31,219,31,250,31,6,31,123,31,123,30,149,31,52,31,143,31,143,30,143,29,231,31,197,31,197,30,197,29,52,31,14,31,122,31,246,31,193,31,193,30,248,31,206,31,206,30,117,31,233,31,136,31,136,30,4,31,127,31,36,31,131,31,107,31,150,31,123,31,99,31,244,31,244,30,194,31,50,31,253,31,130,31,189,31,170,31,234,31,176,31,176,30,219,31,191,31,95,31,40,31,150,31,204,31,203,31,252,31,153,31,153,30,153,29,153,28,85,31,144,31,20,31,154,31,61,31,1,31,1,30,177,31,130,31,146,31,120,31,120,30,161,31,161,30,49,31,49,30,111,31,220,31,64,31,64,30,64,29,195,31,195,30,78,31,194,31,182,31,206,31,165,31);

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
