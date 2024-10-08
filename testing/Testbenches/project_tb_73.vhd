-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_73 is
end project_tb_73;

architecture project_tb_arch_73 of project_tb_73 is
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

constant SCENARIO_LENGTH : integer := 837;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (27,0,3,0,170,0,0,0,103,0,175,0,164,0,142,0,0,0,0,0,0,0,0,0,221,0,202,0,0,0,0,0,206,0,69,0,103,0,84,0,121,0,17,0,0,0,127,0,32,0,115,0,87,0,0,0,0,0,0,0,149,0,241,0,250,0,179,0,210,0,64,0,7,0,0,0,134,0,154,0,167,0,0,0,0,0,127,0,156,0,0,0,13,0,144,0,227,0,203,0,96,0,0,0,157,0,182,0,101,0,155,0,58,0,0,0,251,0,203,0,125,0,210,0,0,0,92,0,179,0,232,0,92,0,37,0,159,0,64,0,186,0,0,0,76,0,127,0,139,0,75,0,0,0,0,0,0,0,0,0,80,0,81,0,209,0,85,0,0,0,109,0,203,0,162,0,173,0,0,0,90,0,89,0,156,0,86,0,49,0,247,0,125,0,95,0,89,0,0,0,92,0,0,0,55,0,224,0,115,0,186,0,0,0,2,0,112,0,5,0,0,0,9,0,53,0,0,0,93,0,0,0,0,0,216,0,0,0,122,0,175,0,164,0,176,0,174,0,102,0,180,0,0,0,36,0,133,0,0,0,84,0,0,0,98,0,68,0,115,0,86,0,0,0,34,0,72,0,0,0,243,0,0,0,21,0,68,0,252,0,88,0,0,0,0,0,64,0,54,0,0,0,193,0,0,0,251,0,237,0,149,0,0,0,26,0,166,0,228,0,164,0,63,0,0,0,211,0,90,0,0,0,100,0,0,0,0,0,236,0,0,0,61,0,74,0,94,0,159,0,95,0,0,0,20,0,99,0,229,0,161,0,0,0,191,0,210,0,130,0,130,0,0,0,8,0,75,0,0,0,0,0,69,0,169,0,179,0,91,0,0,0,153,0,220,0,224,0,9,0,241,0,63,0,147,0,12,0,95,0,199,0,27,0,231,0,230,0,18,0,0,0,150,0,0,0,59,0,28,0,112,0,237,0,0,0,130,0,218,0,52,0,67,0,35,0,73,0,167,0,163,0,0,0,199,0,46,0,82,0,55,0,152,0,145,0,136,0,0,0,0,0,0,0,88,0,191,0,90,0,65,0,58,0,131,0,74,0,137,0,65,0,240,0,0,0,0,0,128,0,191,0,6,0,220,0,11,0,0,0,221,0,19,0,75,0,194,0,0,0,219,0,224,0,241,0,151,0,200,0,0,0,10,0,245,0,125,0,0,0,0,0,126,0,240,0,98,0,223,0,237,0,38,0,120,0,218,0,11,0,151,0,220,0,138,0,150,0,64,0,137,0,0,0,253,0,39,0,14,0,249,0,57,0,0,0,38,0,0,0,43,0,57,0,212,0,185,0,143,0,0,0,0,0,190,0,29,0,82,0,33,0,0,0,186,0,50,0,0,0,4,0,86,0,75,0,215,0,222,0,207,0,239,0,94,0,247,0,0,0,123,0,0,0,183,0,133,0,232,0,141,0,151,0,186,0,74,0,0,0,60,0,0,0,0,0,211,0,74,0,202,0,121,0,49,0,176,0,218,0,0,0,41,0,205,0,0,0,115,0,149,0,12,0,212,0,0,0,0,0,236,0,32,0,216,0,224,0,41,0,0,0,106,0,154,0,168,0,84,0,136,0,241,0,0,0,117,0,239,0,96,0,0,0,22,0,37,0,0,0,15,0,228,0,22,0,118,0,157,0,157,0,35,0,166,0,244,0,224,0,0,0,96,0,32,0,93,0,141,0,149,0,241,0,109,0,197,0,121,0,0,0,0,0,253,0,33,0,169,0,200,0,116,0,101,0,147,0,3,0,137,0,165,0,36,0,19,0,1,0,142,0,66,0,8,0,0,0,83,0,0,0,58,0,76,0,95,0,40,0,97,0,221,0,27,0,56,0,28,0,160,0,204,0,47,0,131,0,53,0,59,0,164,0,96,0,0,0,123,0,56,0,221,0,73,0,0,0,7,0,162,0,0,0,24,0,48,0,233,0,67,0,155,0,72,0,159,0,190,0,115,0,97,0,1,0,0,0,13,0,19,0,77,0,0,0,0,0,109,0,12,0,0,0,111,0,165,0,0,0,213,0,92,0,163,0,89,0,6,0,134,0,110,0,0,0,175,0,0,0,0,0,0,0,242,0,242,0,142,0,189,0,32,0,149,0,174,0,0,0,78,0,69,0,243,0,127,0,229,0,174,0,32,0,12,0,0,0,0,0,96,0,5,0,37,0,209,0,0,0,21,0,0,0,77,0,137,0,228,0,90,0,254,0,161,0,0,0,0,0,0,0,238,0,250,0,103,0,23,0,223,0,0,0,9,0,103,0,31,0,140,0,111,0,229,0,0,0,53,0,198,0,28,0,248,0,138,0,8,0,178,0,0,0,239,0,92,0,24,0,77,0,152,0,68,0,69,0,41,0,0,0,172,0,241,0,231,0,23,0,81,0,31,0,125,0,197,0,181,0,87,0,0,0,0,0,0,0,47,0,191,0,0,0,105,0,189,0,0,0,0,0,198,0,175,0,0,0,0,0,211,0,192,0,225,0,19,0,149,0,89,0,211,0,238,0,116,0,26,0,120,0,150,0,123,0,0,0,178,0,104,0,94,0,250,0,45,0,0,0,238,0,59,0,56,0,8,0,252,0,0,0,107,0,195,0,189,0,0,0,75,0,112,0,199,0,106,0,192,0,213,0,12,0,0,0,76,0,92,0,104,0,0,0,0,0,174,0,108,0,47,0,39,0,11,0,30,0,232,0,60,0,0,0,0,0,247,0,95,0,204,0,23,0,154,0,96,0,0,0,0,0,0,0,214,0,106,0,72,0,43,0,2,0,205,0,0,0,214,0,131,0,0,0,124,0,253,0,200,0,211,0,253,0,221,0,0,0,0,0,37,0,245,0,0,0,74,0,200,0,240,0,0,0,198,0,231,0,228,0,224,0,0,0,30,0,0,0,0,0,55,0,160,0,18,0,189,0,204,0,191,0,255,0,14,0,198,0,132,0,123,0,151,0,19,0,103,0,70,0,41,0,31,0,150,0,250,0,0,0,242,0,149,0,129,0,221,0,68,0,174,0,56,0,30,0,0,0,180,0,85,0,0,0,136,0,193,0,213,0,0,0,112,0,46,0,0,0,248,0,53,0,195,0,193,0,82,0,0,0,0,0,230,0,252,0,111,0,11,0,121,0,223,0,8,0,0,0,45,0,112,0,100,0,65,0,97,0,0,0,0,0,61,0,110,0,109,0,211,0,207,0,52,0,29,0,121,0,0,0,191,0,56,0,35,0,66,0,0,0,0,0,0,0,242,0,205,0,49,0,189,0,111,0,104,0,195,0,41,0,9,0,45,0,163,0,0,0,171,0,251,0,152,0,38,0,102,0,226,0,30,0,0,0,23,0,88,0,0,0,113,0,156,0,142,0,146,0,174,0,129,0,113,0,90,0,196,0,0,0,4,0,223,0,176,0,89,0,176,0,211,0,0,0,17,0,40,0,198,0,25,0,174,0,130,0,16,0,47,0,147,0,0,0,0,0,239,0,0,0,33,0,46,0,171,0,0,0,22,0,43,0,130,0,8,0,208,0,0,0,0,0,123,0,0,0,9,0,109,0,94,0,228,0,0,0,0,0,239,0,38,0,243,0,0,0,0,0,0,0,12,0,206,0,148,0,0,0,44,0,94,0,135,0,83,0,236,0,222,0,54,0,0,0,0,0,72,0,161,0,0,0,186,0,252,0,59,0,114,0,244,0,114,0,0,0,219,0,0,0,61,0,74,0);
signal scenario_full  : scenario_type := (27,31,3,31,170,31,170,30,103,31,175,31,164,31,142,31,142,30,142,29,142,28,142,27,221,31,202,31,202,30,202,29,206,31,69,31,103,31,84,31,121,31,17,31,17,30,127,31,32,31,115,31,87,31,87,30,87,29,87,28,149,31,241,31,250,31,179,31,210,31,64,31,7,31,7,30,134,31,154,31,167,31,167,30,167,29,127,31,156,31,156,30,13,31,144,31,227,31,203,31,96,31,96,30,157,31,182,31,101,31,155,31,58,31,58,30,251,31,203,31,125,31,210,31,210,30,92,31,179,31,232,31,92,31,37,31,159,31,64,31,186,31,186,30,76,31,127,31,139,31,75,31,75,30,75,29,75,28,75,27,80,31,81,31,209,31,85,31,85,30,109,31,203,31,162,31,173,31,173,30,90,31,89,31,156,31,86,31,49,31,247,31,125,31,95,31,89,31,89,30,92,31,92,30,55,31,224,31,115,31,186,31,186,30,2,31,112,31,5,31,5,30,9,31,53,31,53,30,93,31,93,30,93,29,216,31,216,30,122,31,175,31,164,31,176,31,174,31,102,31,180,31,180,30,36,31,133,31,133,30,84,31,84,30,98,31,68,31,115,31,86,31,86,30,34,31,72,31,72,30,243,31,243,30,21,31,68,31,252,31,88,31,88,30,88,29,64,31,54,31,54,30,193,31,193,30,251,31,237,31,149,31,149,30,26,31,166,31,228,31,164,31,63,31,63,30,211,31,90,31,90,30,100,31,100,30,100,29,236,31,236,30,61,31,74,31,94,31,159,31,95,31,95,30,20,31,99,31,229,31,161,31,161,30,191,31,210,31,130,31,130,31,130,30,8,31,75,31,75,30,75,29,69,31,169,31,179,31,91,31,91,30,153,31,220,31,224,31,9,31,241,31,63,31,147,31,12,31,95,31,199,31,27,31,231,31,230,31,18,31,18,30,150,31,150,30,59,31,28,31,112,31,237,31,237,30,130,31,218,31,52,31,67,31,35,31,73,31,167,31,163,31,163,30,199,31,46,31,82,31,55,31,152,31,145,31,136,31,136,30,136,29,136,28,88,31,191,31,90,31,65,31,58,31,131,31,74,31,137,31,65,31,240,31,240,30,240,29,128,31,191,31,6,31,220,31,11,31,11,30,221,31,19,31,75,31,194,31,194,30,219,31,224,31,241,31,151,31,200,31,200,30,10,31,245,31,125,31,125,30,125,29,126,31,240,31,98,31,223,31,237,31,38,31,120,31,218,31,11,31,151,31,220,31,138,31,150,31,64,31,137,31,137,30,253,31,39,31,14,31,249,31,57,31,57,30,38,31,38,30,43,31,57,31,212,31,185,31,143,31,143,30,143,29,190,31,29,31,82,31,33,31,33,30,186,31,50,31,50,30,4,31,86,31,75,31,215,31,222,31,207,31,239,31,94,31,247,31,247,30,123,31,123,30,183,31,133,31,232,31,141,31,151,31,186,31,74,31,74,30,60,31,60,30,60,29,211,31,74,31,202,31,121,31,49,31,176,31,218,31,218,30,41,31,205,31,205,30,115,31,149,31,12,31,212,31,212,30,212,29,236,31,32,31,216,31,224,31,41,31,41,30,106,31,154,31,168,31,84,31,136,31,241,31,241,30,117,31,239,31,96,31,96,30,22,31,37,31,37,30,15,31,228,31,22,31,118,31,157,31,157,31,35,31,166,31,244,31,224,31,224,30,96,31,32,31,93,31,141,31,149,31,241,31,109,31,197,31,121,31,121,30,121,29,253,31,33,31,169,31,200,31,116,31,101,31,147,31,3,31,137,31,165,31,36,31,19,31,1,31,142,31,66,31,8,31,8,30,83,31,83,30,58,31,76,31,95,31,40,31,97,31,221,31,27,31,56,31,28,31,160,31,204,31,47,31,131,31,53,31,59,31,164,31,96,31,96,30,123,31,56,31,221,31,73,31,73,30,7,31,162,31,162,30,24,31,48,31,233,31,67,31,155,31,72,31,159,31,190,31,115,31,97,31,1,31,1,30,13,31,19,31,77,31,77,30,77,29,109,31,12,31,12,30,111,31,165,31,165,30,213,31,92,31,163,31,89,31,6,31,134,31,110,31,110,30,175,31,175,30,175,29,175,28,242,31,242,31,142,31,189,31,32,31,149,31,174,31,174,30,78,31,69,31,243,31,127,31,229,31,174,31,32,31,12,31,12,30,12,29,96,31,5,31,37,31,209,31,209,30,21,31,21,30,77,31,137,31,228,31,90,31,254,31,161,31,161,30,161,29,161,28,238,31,250,31,103,31,23,31,223,31,223,30,9,31,103,31,31,31,140,31,111,31,229,31,229,30,53,31,198,31,28,31,248,31,138,31,8,31,178,31,178,30,239,31,92,31,24,31,77,31,152,31,68,31,69,31,41,31,41,30,172,31,241,31,231,31,23,31,81,31,31,31,125,31,197,31,181,31,87,31,87,30,87,29,87,28,47,31,191,31,191,30,105,31,189,31,189,30,189,29,198,31,175,31,175,30,175,29,211,31,192,31,225,31,19,31,149,31,89,31,211,31,238,31,116,31,26,31,120,31,150,31,123,31,123,30,178,31,104,31,94,31,250,31,45,31,45,30,238,31,59,31,56,31,8,31,252,31,252,30,107,31,195,31,189,31,189,30,75,31,112,31,199,31,106,31,192,31,213,31,12,31,12,30,76,31,92,31,104,31,104,30,104,29,174,31,108,31,47,31,39,31,11,31,30,31,232,31,60,31,60,30,60,29,247,31,95,31,204,31,23,31,154,31,96,31,96,30,96,29,96,28,214,31,106,31,72,31,43,31,2,31,205,31,205,30,214,31,131,31,131,30,124,31,253,31,200,31,211,31,253,31,221,31,221,30,221,29,37,31,245,31,245,30,74,31,200,31,240,31,240,30,198,31,231,31,228,31,224,31,224,30,30,31,30,30,30,29,55,31,160,31,18,31,189,31,204,31,191,31,255,31,14,31,198,31,132,31,123,31,151,31,19,31,103,31,70,31,41,31,31,31,150,31,250,31,250,30,242,31,149,31,129,31,221,31,68,31,174,31,56,31,30,31,30,30,180,31,85,31,85,30,136,31,193,31,213,31,213,30,112,31,46,31,46,30,248,31,53,31,195,31,193,31,82,31,82,30,82,29,230,31,252,31,111,31,11,31,121,31,223,31,8,31,8,30,45,31,112,31,100,31,65,31,97,31,97,30,97,29,61,31,110,31,109,31,211,31,207,31,52,31,29,31,121,31,121,30,191,31,56,31,35,31,66,31,66,30,66,29,66,28,242,31,205,31,49,31,189,31,111,31,104,31,195,31,41,31,9,31,45,31,163,31,163,30,171,31,251,31,152,31,38,31,102,31,226,31,30,31,30,30,23,31,88,31,88,30,113,31,156,31,142,31,146,31,174,31,129,31,113,31,90,31,196,31,196,30,4,31,223,31,176,31,89,31,176,31,211,31,211,30,17,31,40,31,198,31,25,31,174,31,130,31,16,31,47,31,147,31,147,30,147,29,239,31,239,30,33,31,46,31,171,31,171,30,22,31,43,31,130,31,8,31,208,31,208,30,208,29,123,31,123,30,9,31,109,31,94,31,228,31,228,30,228,29,239,31,38,31,243,31,243,30,243,29,243,28,12,31,206,31,148,31,148,30,44,31,94,31,135,31,83,31,236,31,222,31,54,31,54,30,54,29,72,31,161,31,161,30,186,31,252,31,59,31,114,31,244,31,114,31,114,30,219,31,219,30,61,31,74,31);

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
