-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 834;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (54,0,118,0,82,0,16,0,0,0,45,0,0,0,0,0,45,0,0,0,156,0,78,0,0,0,0,0,80,0,194,0,218,0,144,0,210,0,7,0,0,0,214,0,25,0,64,0,188,0,80,0,137,0,213,0,114,0,237,0,102,0,154,0,0,0,0,0,169,0,206,0,0,0,244,0,23,0,118,0,237,0,155,0,247,0,196,0,164,0,111,0,44,0,167,0,217,0,0,0,0,0,202,0,0,0,0,0,97,0,21,0,0,0,167,0,0,0,178,0,16,0,0,0,51,0,6,0,109,0,106,0,0,0,40,0,218,0,110,0,0,0,65,0,231,0,21,0,174,0,195,0,80,0,101,0,38,0,60,0,78,0,92,0,76,0,28,0,209,0,0,0,88,0,116,0,0,0,138,0,178,0,165,0,59,0,0,0,31,0,161,0,33,0,14,0,224,0,109,0,152,0,111,0,0,0,0,0,0,0,117,0,0,0,161,0,122,0,0,0,155,0,8,0,200,0,220,0,0,0,183,0,72,0,0,0,28,0,152,0,22,0,171,0,4,0,12,0,119,0,0,0,50,0,105,0,151,0,84,0,145,0,0,0,10,0,0,0,213,0,0,0,157,0,74,0,15,0,87,0,0,0,51,0,107,0,0,0,107,0,0,0,231,0,117,0,162,0,0,0,172,0,0,0,241,0,229,0,243,0,11,0,169,0,110,0,0,0,0,0,199,0,203,0,0,0,150,0,185,0,11,0,35,0,152,0,70,0,204,0,0,0,152,0,0,0,0,0,66,0,0,0,202,0,0,0,0,0,5,0,14,0,98,0,155,0,38,0,152,0,20,0,0,0,74,0,105,0,112,0,0,0,35,0,164,0,94,0,154,0,0,0,242,0,42,0,0,0,92,0,132,0,45,0,183,0,200,0,127,0,0,0,0,0,17,0,204,0,163,0,232,0,41,0,201,0,185,0,183,0,68,0,185,0,156,0,117,0,0,0,131,0,27,0,252,0,96,0,213,0,2,0,29,0,225,0,148,0,97,0,238,0,53,0,17,0,45,0,0,0,45,0,0,0,189,0,213,0,199,0,26,0,0,0,0,0,0,0,145,0,193,0,0,0,57,0,53,0,15,0,64,0,30,0,100,0,97,0,204,0,0,0,124,0,130,0,133,0,73,0,239,0,40,0,81,0,125,0,0,0,91,0,41,0,0,0,1,0,71,0,239,0,0,0,0,0,0,0,118,0,26,0,213,0,0,0,68,0,169,0,30,0,89,0,155,0,0,0,0,0,0,0,49,0,178,0,114,0,25,0,144,0,91,0,247,0,122,0,235,0,179,0,84,0,0,0,133,0,148,0,226,0,224,0,162,0,19,0,0,0,14,0,184,0,106,0,27,0,0,0,223,0,1,0,0,0,43,0,211,0,0,0,0,0,0,0,77,0,211,0,0,0,0,0,151,0,122,0,58,0,0,0,195,0,255,0,238,0,36,0,96,0,0,0,13,0,40,0,135,0,154,0,225,0,3,0,36,0,227,0,247,0,44,0,82,0,0,0,81,0,166,0,251,0,27,0,17,0,204,0,8,0,34,0,9,0,26,0,201,0,1,0,0,0,35,0,207,0,184,0,0,0,142,0,112,0,233,0,185,0,173,0,0,0,59,0,194,0,119,0,127,0,122,0,230,0,0,0,21,0,210,0,140,0,10,0,39,0,0,0,183,0,60,0,208,0,0,0,0,0,175,0,58,0,0,0,43,0,0,0,31,0,206,0,101,0,29,0,226,0,53,0,152,0,40,0,141,0,186,0,0,0,28,0,72,0,212,0,93,0,177,0,28,0,238,0,242,0,209,0,207,0,111,0,121,0,0,0,125,0,55,0,105,0,92,0,234,0,245,0,194,0,128,0,22,0,146,0,215,0,0,0,174,0,145,0,220,0,4,0,0,0,0,0,122,0,215,0,245,0,254,0,217,0,134,0,235,0,236,0,55,0,164,0,0,0,16,0,133,0,242,0,110,0,56,0,170,0,0,0,250,0,136,0,234,0,0,0,150,0,0,0,23,0,0,0,146,0,42,0,0,0,172,0,43,0,0,0,93,0,0,0,252,0,255,0,130,0,229,0,0,0,123,0,137,0,0,0,5,0,22,0,204,0,0,0,185,0,31,0,126,0,0,0,0,0,96,0,61,0,1,0,0,0,83,0,25,0,0,0,0,0,0,0,192,0,81,0,52,0,0,0,0,0,29,0,63,0,30,0,21,0,104,0,0,0,221,0,178,0,0,0,49,0,0,0,177,0,184,0,0,0,75,0,89,0,194,0,171,0,136,0,213,0,130,0,153,0,0,0,0,0,90,0,141,0,0,0,0,0,80,0,45,0,0,0,11,0,173,0,150,0,57,0,0,0,86,0,121,0,0,0,153,0,33,0,176,0,0,0,139,0,203,0,46,0,83,0,87,0,0,0,128,0,64,0,0,0,145,0,222,0,167,0,81,0,141,0,0,0,0,0,25,0,20,0,202,0,136,0,52,0,209,0,186,0,197,0,79,0,147,0,139,0,48,0,166,0,0,0,67,0,216,0,106,0,227,0,46,0,0,0,0,0,10,0,141,0,134,0,48,0,129,0,216,0,247,0,227,0,9,0,47,0,0,0,187,0,107,0,30,0,207,0,0,0,0,0,117,0,4,0,243,0,93,0,229,0,121,0,169,0,21,0,4,0,0,0,186,0,122,0,28,0,0,0,0,0,0,0,0,0,14,0,211,0,238,0,68,0,230,0,169,0,48,0,88,0,55,0,192,0,30,0,172,0,180,0,0,0,0,0,97,0,176,0,131,0,185,0,0,0,225,0,233,0,109,0,0,0,36,0,40,0,193,0,235,0,172,0,81,0,124,0,237,0,27,0,1,0,220,0,50,0,29,0,2,0,86,0,156,0,110,0,191,0,115,0,68,0,0,0,143,0,56,0,0,0,57,0,0,0,88,0,121,0,253,0,0,0,0,0,204,0,17,0,220,0,207,0,34,0,76,0,197,0,161,0,17,0,174,0,39,0,0,0,124,0,116,0,142,0,0,0,142,0,16,0,85,0,0,0,237,0,39,0,79,0,90,0,0,0,125,0,105,0,194,0,93,0,72,0,7,0,153,0,83,0,36,0,87,0,226,0,0,0,178,0,0,0,0,0,180,0,0,0,177,0,0,0,67,0,0,0,0,0,186,0,172,0,34,0,241,0,0,0,21,0,88,0,85,0,95,0,146,0,178,0,41,0,233,0,43,0,76,0,240,0,196,0,80,0,205,0,0,0,3,0,44,0,0,0,180,0,247,0,113,0,0,0,0,0,108,0,146,0,162,0,183,0,243,0,147,0,189,0,100,0,186,0,0,0,255,0,249,0,143,0,209,0,156,0,0,0,145,0,218,0,0,0,123,0,126,0,152,0,32,0,21,0,19,0,14,0,163,0,89,0,0,0,11,0,191,0,165,0,254,0,190,0,108,0,0,0,119,0,234,0,250,0,46,0,158,0,1,0,188,0,120,0,229,0,0,0,0,0,146,0,78,0,100,0,198,0,51,0,0,0,187,0,0,0,78,0,215,0,84,0,33,0,0,0,0,0,0,0,85,0,0,0,35,0,23,0,0,0,0,0,10,0,82,0,0,0,165,0,0,0,59,0,58,0,159,0,69,0,176,0,81,0,128,0,0,0,0,0,0,0,169,0,0,0,132,0,160,0,0,0,49,0,245,0,116,0,0,0,0,0);
signal scenario_full  : scenario_type := (54,31,118,31,82,31,16,31,16,30,45,31,45,30,45,29,45,31,45,30,156,31,78,31,78,30,78,29,80,31,194,31,218,31,144,31,210,31,7,31,7,30,214,31,25,31,64,31,188,31,80,31,137,31,213,31,114,31,237,31,102,31,154,31,154,30,154,29,169,31,206,31,206,30,244,31,23,31,118,31,237,31,155,31,247,31,196,31,164,31,111,31,44,31,167,31,217,31,217,30,217,29,202,31,202,30,202,29,97,31,21,31,21,30,167,31,167,30,178,31,16,31,16,30,51,31,6,31,109,31,106,31,106,30,40,31,218,31,110,31,110,30,65,31,231,31,21,31,174,31,195,31,80,31,101,31,38,31,60,31,78,31,92,31,76,31,28,31,209,31,209,30,88,31,116,31,116,30,138,31,178,31,165,31,59,31,59,30,31,31,161,31,33,31,14,31,224,31,109,31,152,31,111,31,111,30,111,29,111,28,117,31,117,30,161,31,122,31,122,30,155,31,8,31,200,31,220,31,220,30,183,31,72,31,72,30,28,31,152,31,22,31,171,31,4,31,12,31,119,31,119,30,50,31,105,31,151,31,84,31,145,31,145,30,10,31,10,30,213,31,213,30,157,31,74,31,15,31,87,31,87,30,51,31,107,31,107,30,107,31,107,30,231,31,117,31,162,31,162,30,172,31,172,30,241,31,229,31,243,31,11,31,169,31,110,31,110,30,110,29,199,31,203,31,203,30,150,31,185,31,11,31,35,31,152,31,70,31,204,31,204,30,152,31,152,30,152,29,66,31,66,30,202,31,202,30,202,29,5,31,14,31,98,31,155,31,38,31,152,31,20,31,20,30,74,31,105,31,112,31,112,30,35,31,164,31,94,31,154,31,154,30,242,31,42,31,42,30,92,31,132,31,45,31,183,31,200,31,127,31,127,30,127,29,17,31,204,31,163,31,232,31,41,31,201,31,185,31,183,31,68,31,185,31,156,31,117,31,117,30,131,31,27,31,252,31,96,31,213,31,2,31,29,31,225,31,148,31,97,31,238,31,53,31,17,31,45,31,45,30,45,31,45,30,189,31,213,31,199,31,26,31,26,30,26,29,26,28,145,31,193,31,193,30,57,31,53,31,15,31,64,31,30,31,100,31,97,31,204,31,204,30,124,31,130,31,133,31,73,31,239,31,40,31,81,31,125,31,125,30,91,31,41,31,41,30,1,31,71,31,239,31,239,30,239,29,239,28,118,31,26,31,213,31,213,30,68,31,169,31,30,31,89,31,155,31,155,30,155,29,155,28,49,31,178,31,114,31,25,31,144,31,91,31,247,31,122,31,235,31,179,31,84,31,84,30,133,31,148,31,226,31,224,31,162,31,19,31,19,30,14,31,184,31,106,31,27,31,27,30,223,31,1,31,1,30,43,31,211,31,211,30,211,29,211,28,77,31,211,31,211,30,211,29,151,31,122,31,58,31,58,30,195,31,255,31,238,31,36,31,96,31,96,30,13,31,40,31,135,31,154,31,225,31,3,31,36,31,227,31,247,31,44,31,82,31,82,30,81,31,166,31,251,31,27,31,17,31,204,31,8,31,34,31,9,31,26,31,201,31,1,31,1,30,35,31,207,31,184,31,184,30,142,31,112,31,233,31,185,31,173,31,173,30,59,31,194,31,119,31,127,31,122,31,230,31,230,30,21,31,210,31,140,31,10,31,39,31,39,30,183,31,60,31,208,31,208,30,208,29,175,31,58,31,58,30,43,31,43,30,31,31,206,31,101,31,29,31,226,31,53,31,152,31,40,31,141,31,186,31,186,30,28,31,72,31,212,31,93,31,177,31,28,31,238,31,242,31,209,31,207,31,111,31,121,31,121,30,125,31,55,31,105,31,92,31,234,31,245,31,194,31,128,31,22,31,146,31,215,31,215,30,174,31,145,31,220,31,4,31,4,30,4,29,122,31,215,31,245,31,254,31,217,31,134,31,235,31,236,31,55,31,164,31,164,30,16,31,133,31,242,31,110,31,56,31,170,31,170,30,250,31,136,31,234,31,234,30,150,31,150,30,23,31,23,30,146,31,42,31,42,30,172,31,43,31,43,30,93,31,93,30,252,31,255,31,130,31,229,31,229,30,123,31,137,31,137,30,5,31,22,31,204,31,204,30,185,31,31,31,126,31,126,30,126,29,96,31,61,31,1,31,1,30,83,31,25,31,25,30,25,29,25,28,192,31,81,31,52,31,52,30,52,29,29,31,63,31,30,31,21,31,104,31,104,30,221,31,178,31,178,30,49,31,49,30,177,31,184,31,184,30,75,31,89,31,194,31,171,31,136,31,213,31,130,31,153,31,153,30,153,29,90,31,141,31,141,30,141,29,80,31,45,31,45,30,11,31,173,31,150,31,57,31,57,30,86,31,121,31,121,30,153,31,33,31,176,31,176,30,139,31,203,31,46,31,83,31,87,31,87,30,128,31,64,31,64,30,145,31,222,31,167,31,81,31,141,31,141,30,141,29,25,31,20,31,202,31,136,31,52,31,209,31,186,31,197,31,79,31,147,31,139,31,48,31,166,31,166,30,67,31,216,31,106,31,227,31,46,31,46,30,46,29,10,31,141,31,134,31,48,31,129,31,216,31,247,31,227,31,9,31,47,31,47,30,187,31,107,31,30,31,207,31,207,30,207,29,117,31,4,31,243,31,93,31,229,31,121,31,169,31,21,31,4,31,4,30,186,31,122,31,28,31,28,30,28,29,28,28,28,27,14,31,211,31,238,31,68,31,230,31,169,31,48,31,88,31,55,31,192,31,30,31,172,31,180,31,180,30,180,29,97,31,176,31,131,31,185,31,185,30,225,31,233,31,109,31,109,30,36,31,40,31,193,31,235,31,172,31,81,31,124,31,237,31,27,31,1,31,220,31,50,31,29,31,2,31,86,31,156,31,110,31,191,31,115,31,68,31,68,30,143,31,56,31,56,30,57,31,57,30,88,31,121,31,253,31,253,30,253,29,204,31,17,31,220,31,207,31,34,31,76,31,197,31,161,31,17,31,174,31,39,31,39,30,124,31,116,31,142,31,142,30,142,31,16,31,85,31,85,30,237,31,39,31,79,31,90,31,90,30,125,31,105,31,194,31,93,31,72,31,7,31,153,31,83,31,36,31,87,31,226,31,226,30,178,31,178,30,178,29,180,31,180,30,177,31,177,30,67,31,67,30,67,29,186,31,172,31,34,31,241,31,241,30,21,31,88,31,85,31,95,31,146,31,178,31,41,31,233,31,43,31,76,31,240,31,196,31,80,31,205,31,205,30,3,31,44,31,44,30,180,31,247,31,113,31,113,30,113,29,108,31,146,31,162,31,183,31,243,31,147,31,189,31,100,31,186,31,186,30,255,31,249,31,143,31,209,31,156,31,156,30,145,31,218,31,218,30,123,31,126,31,152,31,32,31,21,31,19,31,14,31,163,31,89,31,89,30,11,31,191,31,165,31,254,31,190,31,108,31,108,30,119,31,234,31,250,31,46,31,158,31,1,31,188,31,120,31,229,31,229,30,229,29,146,31,78,31,100,31,198,31,51,31,51,30,187,31,187,30,78,31,215,31,84,31,33,31,33,30,33,29,33,28,85,31,85,30,35,31,23,31,23,30,23,29,10,31,82,31,82,30,165,31,165,30,59,31,58,31,159,31,69,31,176,31,81,31,128,31,128,30,128,29,128,28,169,31,169,30,132,31,160,31,160,30,49,31,245,31,116,31,116,30,116,29);

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
