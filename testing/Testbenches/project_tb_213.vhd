-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_213 is
end project_tb_213;

architecture project_tb_arch_213 of project_tb_213 is
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

constant SCENARIO_LENGTH : integer := 807;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (158,0,141,0,58,0,52,0,122,0,0,0,141,0,172,0,245,0,140,0,203,0,119,0,57,0,219,0,58,0,29,0,194,0,0,0,212,0,11,0,234,0,112,0,107,0,178,0,99,0,133,0,212,0,110,0,131,0,232,0,1,0,93,0,108,0,227,0,0,0,185,0,37,0,50,0,72,0,101,0,0,0,7,0,0,0,214,0,171,0,48,0,143,0,167,0,170,0,162,0,93,0,0,0,125,0,65,0,194,0,210,0,107,0,105,0,0,0,11,0,209,0,79,0,174,0,54,0,0,0,29,0,216,0,228,0,12,0,217,0,0,0,96,0,9,0,6,0,186,0,56,0,119,0,179,0,164,0,160,0,8,0,59,0,0,0,27,0,0,0,183,0,220,0,123,0,16,0,217,0,222,0,145,0,151,0,73,0,212,0,26,0,23,0,0,0,231,0,102,0,69,0,0,0,81,0,0,0,61,0,233,0,18,0,30,0,188,0,187,0,88,0,30,0,1,0,220,0,137,0,32,0,0,0,10,0,151,0,0,0,28,0,222,0,115,0,60,0,0,0,82,0,0,0,87,0,219,0,0,0,50,0,0,0,43,0,187,0,220,0,130,0,69,0,105,0,0,0,114,0,0,0,107,0,149,0,68,0,125,0,189,0,248,0,56,0,73,0,24,0,120,0,0,0,168,0,74,0,238,0,0,0,161,0,15,0,227,0,111,0,195,0,140,0,4,0,154,0,115,0,244,0,0,0,0,0,0,0,110,0,159,0,212,0,158,0,0,0,144,0,190,0,7,0,201,0,0,0,235,0,46,0,0,0,186,0,247,0,0,0,167,0,208,0,0,0,0,0,130,0,121,0,223,0,151,0,13,0,139,0,127,0,140,0,107,0,198,0,0,0,242,0,68,0,0,0,0,0,86,0,167,0,0,0,178,0,65,0,147,0,9,0,228,0,0,0,0,0,64,0,72,0,132,0,0,0,93,0,188,0,159,0,125,0,76,0,163,0,30,0,16,0,252,0,90,0,216,0,132,0,0,0,113,0,111,0,13,0,15,0,70,0,217,0,0,0,0,0,252,0,134,0,10,0,245,0,113,0,121,0,176,0,92,0,126,0,58,0,52,0,140,0,86,0,129,0,0,0,38,0,150,0,0,0,11,0,97,0,222,0,241,0,96,0,0,0,0,0,0,0,0,0,212,0,0,0,0,0,42,0,237,0,132,0,225,0,199,0,143,0,127,0,205,0,108,0,227,0,123,0,218,0,216,0,119,0,142,0,175,0,0,0,187,0,166,0,216,0,0,0,159,0,191,0,77,0,203,0,231,0,180,0,114,0,205,0,235,0,135,0,26,0,36,0,111,0,9,0,228,0,0,0,0,0,119,0,17,0,121,0,204,0,54,0,13,0,125,0,91,0,212,0,124,0,27,0,177,0,243,0,125,0,0,0,216,0,242,0,116,0,136,0,0,0,0,0,62,0,22,0,240,0,0,0,247,0,0,0,247,0,5,0,21,0,0,0,128,0,133,0,92,0,0,0,134,0,121,0,168,0,70,0,227,0,167,0,133,0,23,0,124,0,0,0,111,0,63,0,255,0,0,0,54,0,0,0,128,0,16,0,74,0,6,0,1,0,191,0,112,0,102,0,133,0,108,0,201,0,162,0,244,0,56,0,54,0,203,0,246,0,0,0,153,0,70,0,157,0,0,0,250,0,35,0,0,0,154,0,79,0,30,0,176,0,104,0,0,0,0,0,209,0,216,0,97,0,11,0,0,0,192,0,0,0,120,0,10,0,73,0,166,0,164,0,40,0,198,0,0,0,13,0,24,0,59,0,171,0,121,0,0,0,127,0,185,0,215,0,239,0,146,0,101,0,0,0,200,0,219,0,45,0,33,0,0,0,132,0,254,0,241,0,231,0,99,0,11,0,0,0,0,0,1,0,175,0,206,0,217,0,102,0,134,0,72,0,23,0,65,0,0,0,230,0,100,0,21,0,78,0,0,0,207,0,21,0,75,0,89,0,80,0,0,0,73,0,0,0,14,0,246,0,0,0,164,0,57,0,245,0,0,0,77,0,233,0,95,0,221,0,224,0,3,0,0,0,1,0,0,0,114,0,168,0,63,0,181,0,2,0,53,0,192,0,195,0,40,0,6,0,130,0,0,0,167,0,105,0,25,0,75,0,3,0,113,0,82,0,0,0,230,0,205,0,23,0,0,0,84,0,0,0,226,0,63,0,0,0,252,0,246,0,12,0,0,0,148,0,253,0,253,0,63,0,0,0,168,0,84,0,74,0,216,0,178,0,16,0,95,0,0,0,44,0,89,0,20,0,198,0,0,0,26,0,169,0,0,0,244,0,6,0,0,0,21,0,126,0,68,0,181,0,226,0,245,0,9,0,194,0,189,0,14,0,10,0,230,0,3,0,183,0,0,0,85,0,0,0,123,0,114,0,234,0,0,0,206,0,0,0,230,0,63,0,187,0,30,0,45,0,252,0,123,0,186,0,0,0,0,0,0,0,246,0,222,0,113,0,21,0,0,0,185,0,231,0,14,0,166,0,218,0,124,0,180,0,241,0,53,0,38,0,101,0,101,0,227,0,249,0,156,0,96,0,125,0,0,0,72,0,0,0,63,0,0,0,116,0,25,0,38,0,0,0,17,0,123,0,0,0,209,0,41,0,117,0,219,0,153,0,0,0,220,0,111,0,22,0,237,0,0,0,224,0,203,0,174,0,69,0,54,0,132,0,205,0,0,0,164,0,0,0,143,0,121,0,189,0,0,0,209,0,252,0,232,0,115,0,133,0,168,0,102,0,110,0,102,0,24,0,227,0,4,0,212,0,124,0,0,0,113,0,175,0,192,0,4,0,243,0,118,0,99,0,109,0,11,0,150,0,0,0,193,0,0,0,0,0,0,0,207,0,0,0,63,0,28,0,27,0,227,0,28,0,120,0,52,0,10,0,27,0,209,0,111,0,56,0,22,0,0,0,2,0,175,0,0,0,17,0,64,0,222,0,0,0,199,0,172,0,0,0,240,0,0,0,0,0,162,0,254,0,0,0,56,0,233,0,93,0,202,0,209,0,226,0,71,0,44,0,175,0,97,0,37,0,49,0,133,0,126,0,0,0,79,0,1,0,38,0,248,0,205,0,0,0,193,0,45,0,24,0,0,0,0,0,99,0,168,0,180,0,22,0,162,0,199,0,0,0,128,0,18,0,169,0,206,0,95,0,132,0,86,0,34,0,170,0,118,0,194,0,164,0,0,0,221,0,0,0,192,0,167,0,154,0,158,0,0,0,6,0,35,0,52,0,57,0,29,0,82,0,25,0,0,0,155,0,192,0,32,0,165,0,157,0,150,0,105,0,215,0,0,0,170,0,191,0,154,0,70,0,0,0,2,0,140,0,84,0,249,0,159,0,32,0,254,0,105,0,228,0,137,0,168,0,245,0,36,0,93,0,0,0,138,0,159,0,45,0,55,0,27,0,157,0,66,0,99,0,61,0,65,0,97,0,138,0,35,0,21,0,228,0,94,0,92,0,0,0,61,0,113,0,0,0,192,0,9,0,0,0,81,0,149,0,178,0,57,0,49,0,91,0,139,0,0,0,247,0,43,0,87,0);
signal scenario_full  : scenario_type := (158,31,141,31,58,31,52,31,122,31,122,30,141,31,172,31,245,31,140,31,203,31,119,31,57,31,219,31,58,31,29,31,194,31,194,30,212,31,11,31,234,31,112,31,107,31,178,31,99,31,133,31,212,31,110,31,131,31,232,31,1,31,93,31,108,31,227,31,227,30,185,31,37,31,50,31,72,31,101,31,101,30,7,31,7,30,214,31,171,31,48,31,143,31,167,31,170,31,162,31,93,31,93,30,125,31,65,31,194,31,210,31,107,31,105,31,105,30,11,31,209,31,79,31,174,31,54,31,54,30,29,31,216,31,228,31,12,31,217,31,217,30,96,31,9,31,6,31,186,31,56,31,119,31,179,31,164,31,160,31,8,31,59,31,59,30,27,31,27,30,183,31,220,31,123,31,16,31,217,31,222,31,145,31,151,31,73,31,212,31,26,31,23,31,23,30,231,31,102,31,69,31,69,30,81,31,81,30,61,31,233,31,18,31,30,31,188,31,187,31,88,31,30,31,1,31,220,31,137,31,32,31,32,30,10,31,151,31,151,30,28,31,222,31,115,31,60,31,60,30,82,31,82,30,87,31,219,31,219,30,50,31,50,30,43,31,187,31,220,31,130,31,69,31,105,31,105,30,114,31,114,30,107,31,149,31,68,31,125,31,189,31,248,31,56,31,73,31,24,31,120,31,120,30,168,31,74,31,238,31,238,30,161,31,15,31,227,31,111,31,195,31,140,31,4,31,154,31,115,31,244,31,244,30,244,29,244,28,110,31,159,31,212,31,158,31,158,30,144,31,190,31,7,31,201,31,201,30,235,31,46,31,46,30,186,31,247,31,247,30,167,31,208,31,208,30,208,29,130,31,121,31,223,31,151,31,13,31,139,31,127,31,140,31,107,31,198,31,198,30,242,31,68,31,68,30,68,29,86,31,167,31,167,30,178,31,65,31,147,31,9,31,228,31,228,30,228,29,64,31,72,31,132,31,132,30,93,31,188,31,159,31,125,31,76,31,163,31,30,31,16,31,252,31,90,31,216,31,132,31,132,30,113,31,111,31,13,31,15,31,70,31,217,31,217,30,217,29,252,31,134,31,10,31,245,31,113,31,121,31,176,31,92,31,126,31,58,31,52,31,140,31,86,31,129,31,129,30,38,31,150,31,150,30,11,31,97,31,222,31,241,31,96,31,96,30,96,29,96,28,96,27,212,31,212,30,212,29,42,31,237,31,132,31,225,31,199,31,143,31,127,31,205,31,108,31,227,31,123,31,218,31,216,31,119,31,142,31,175,31,175,30,187,31,166,31,216,31,216,30,159,31,191,31,77,31,203,31,231,31,180,31,114,31,205,31,235,31,135,31,26,31,36,31,111,31,9,31,228,31,228,30,228,29,119,31,17,31,121,31,204,31,54,31,13,31,125,31,91,31,212,31,124,31,27,31,177,31,243,31,125,31,125,30,216,31,242,31,116,31,136,31,136,30,136,29,62,31,22,31,240,31,240,30,247,31,247,30,247,31,5,31,21,31,21,30,128,31,133,31,92,31,92,30,134,31,121,31,168,31,70,31,227,31,167,31,133,31,23,31,124,31,124,30,111,31,63,31,255,31,255,30,54,31,54,30,128,31,16,31,74,31,6,31,1,31,191,31,112,31,102,31,133,31,108,31,201,31,162,31,244,31,56,31,54,31,203,31,246,31,246,30,153,31,70,31,157,31,157,30,250,31,35,31,35,30,154,31,79,31,30,31,176,31,104,31,104,30,104,29,209,31,216,31,97,31,11,31,11,30,192,31,192,30,120,31,10,31,73,31,166,31,164,31,40,31,198,31,198,30,13,31,24,31,59,31,171,31,121,31,121,30,127,31,185,31,215,31,239,31,146,31,101,31,101,30,200,31,219,31,45,31,33,31,33,30,132,31,254,31,241,31,231,31,99,31,11,31,11,30,11,29,1,31,175,31,206,31,217,31,102,31,134,31,72,31,23,31,65,31,65,30,230,31,100,31,21,31,78,31,78,30,207,31,21,31,75,31,89,31,80,31,80,30,73,31,73,30,14,31,246,31,246,30,164,31,57,31,245,31,245,30,77,31,233,31,95,31,221,31,224,31,3,31,3,30,1,31,1,30,114,31,168,31,63,31,181,31,2,31,53,31,192,31,195,31,40,31,6,31,130,31,130,30,167,31,105,31,25,31,75,31,3,31,113,31,82,31,82,30,230,31,205,31,23,31,23,30,84,31,84,30,226,31,63,31,63,30,252,31,246,31,12,31,12,30,148,31,253,31,253,31,63,31,63,30,168,31,84,31,74,31,216,31,178,31,16,31,95,31,95,30,44,31,89,31,20,31,198,31,198,30,26,31,169,31,169,30,244,31,6,31,6,30,21,31,126,31,68,31,181,31,226,31,245,31,9,31,194,31,189,31,14,31,10,31,230,31,3,31,183,31,183,30,85,31,85,30,123,31,114,31,234,31,234,30,206,31,206,30,230,31,63,31,187,31,30,31,45,31,252,31,123,31,186,31,186,30,186,29,186,28,246,31,222,31,113,31,21,31,21,30,185,31,231,31,14,31,166,31,218,31,124,31,180,31,241,31,53,31,38,31,101,31,101,31,227,31,249,31,156,31,96,31,125,31,125,30,72,31,72,30,63,31,63,30,116,31,25,31,38,31,38,30,17,31,123,31,123,30,209,31,41,31,117,31,219,31,153,31,153,30,220,31,111,31,22,31,237,31,237,30,224,31,203,31,174,31,69,31,54,31,132,31,205,31,205,30,164,31,164,30,143,31,121,31,189,31,189,30,209,31,252,31,232,31,115,31,133,31,168,31,102,31,110,31,102,31,24,31,227,31,4,31,212,31,124,31,124,30,113,31,175,31,192,31,4,31,243,31,118,31,99,31,109,31,11,31,150,31,150,30,193,31,193,30,193,29,193,28,207,31,207,30,63,31,28,31,27,31,227,31,28,31,120,31,52,31,10,31,27,31,209,31,111,31,56,31,22,31,22,30,2,31,175,31,175,30,17,31,64,31,222,31,222,30,199,31,172,31,172,30,240,31,240,30,240,29,162,31,254,31,254,30,56,31,233,31,93,31,202,31,209,31,226,31,71,31,44,31,175,31,97,31,37,31,49,31,133,31,126,31,126,30,79,31,1,31,38,31,248,31,205,31,205,30,193,31,45,31,24,31,24,30,24,29,99,31,168,31,180,31,22,31,162,31,199,31,199,30,128,31,18,31,169,31,206,31,95,31,132,31,86,31,34,31,170,31,118,31,194,31,164,31,164,30,221,31,221,30,192,31,167,31,154,31,158,31,158,30,6,31,35,31,52,31,57,31,29,31,82,31,25,31,25,30,155,31,192,31,32,31,165,31,157,31,150,31,105,31,215,31,215,30,170,31,191,31,154,31,70,31,70,30,2,31,140,31,84,31,249,31,159,31,32,31,254,31,105,31,228,31,137,31,168,31,245,31,36,31,93,31,93,30,138,31,159,31,45,31,55,31,27,31,157,31,66,31,99,31,61,31,65,31,97,31,138,31,35,31,21,31,228,31,94,31,92,31,92,30,61,31,113,31,113,30,192,31,9,31,9,30,81,31,149,31,178,31,57,31,49,31,91,31,139,31,139,30,247,31,43,31,87,31);

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
