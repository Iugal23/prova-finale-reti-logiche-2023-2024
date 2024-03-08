-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_451 is
end project_tb_451;

architecture project_tb_arch_451 of project_tb_451 is
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

constant SCENARIO_LENGTH : integer := 789;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (57,0,70,0,7,0,105,0,0,0,30,0,194,0,10,0,0,0,183,0,111,0,0,0,8,0,158,0,0,0,247,0,0,0,46,0,3,0,56,0,0,0,188,0,76,0,0,0,0,0,243,0,248,0,195,0,105,0,206,0,40,0,0,0,66,0,46,0,11,0,0,0,191,0,236,0,107,0,0,0,126,0,36,0,149,0,246,0,158,0,149,0,148,0,205,0,0,0,0,0,0,0,147,0,0,0,10,0,170,0,95,0,0,0,250,0,0,0,2,0,133,0,39,0,98,0,0,0,210,0,187,0,0,0,88,0,0,0,236,0,158,0,241,0,0,0,143,0,185,0,228,0,0,0,69,0,115,0,159,0,0,0,84,0,0,0,76,0,173,0,163,0,161,0,209,0,251,0,5,0,2,0,190,0,0,0,0,0,251,0,106,0,0,0,212,0,0,0,68,0,74,0,0,0,0,0,174,0,130,0,100,0,0,0,72,0,0,0,63,0,202,0,169,0,144,0,91,0,223,0,214,0,50,0,150,0,220,0,244,0,251,0,39,0,33,0,114,0,172,0,80,0,0,0,6,0,17,0,161,0,178,0,159,0,0,0,35,0,0,0,22,0,0,0,78,0,0,0,23,0,148,0,41,0,168,0,228,0,0,0,0,0,51,0,0,0,167,0,0,0,0,0,7,0,0,0,170,0,223,0,16,0,24,0,246,0,102,0,193,0,43,0,253,0,0,0,132,0,91,0,175,0,170,0,186,0,23,0,91,0,222,0,0,0,227,0,77,0,29,0,41,0,135,0,196,0,192,0,203,0,118,0,171,0,43,0,27,0,223,0,253,0,182,0,113,0,232,0,163,0,29,0,140,0,239,0,0,0,42,0,89,0,96,0,0,0,109,0,0,0,62,0,250,0,80,0,0,0,0,0,63,0,34,0,0,0,0,0,205,0,102,0,253,0,159,0,122,0,0,0,168,0,47,0,113,0,7,0,140,0,103,0,65,0,92,0,90,0,0,0,204,0,94,0,55,0,20,0,82,0,0,0,116,0,60,0,171,0,24,0,118,0,177,0,90,0,163,0,217,0,47,0,0,0,75,0,124,0,123,0,53,0,67,0,90,0,33,0,68,0,0,0,0,0,94,0,0,0,166,0,0,0,0,0,195,0,12,0,0,0,72,0,21,0,14,0,0,0,23,0,0,0,0,0,85,0,173,0,11,0,38,0,0,0,75,0,237,0,117,0,0,0,0,0,131,0,42,0,208,0,40,0,255,0,127,0,146,0,104,0,143,0,193,0,160,0,125,0,127,0,112,0,0,0,98,0,87,0,13,0,177,0,32,0,122,0,221,0,0,0,0,0,124,0,157,0,0,0,137,0,0,0,230,0,91,0,0,0,180,0,160,0,147,0,146,0,119,0,0,0,0,0,167,0,0,0,153,0,40,0,250,0,178,0,101,0,117,0,68,0,175,0,23,0,9,0,0,0,0,0,20,0,196,0,46,0,40,0,33,0,147,0,63,0,116,0,0,0,249,0,210,0,41,0,66,0,23,0,161,0,68,0,140,0,118,0,213,0,0,0,93,0,139,0,230,0,189,0,61,0,155,0,0,0,79,0,226,0,0,0,77,0,91,0,99,0,0,0,1,0,0,0,0,0,215,0,121,0,253,0,155,0,97,0,49,0,17,0,0,0,45,0,0,0,33,0,0,0,0,0,237,0,0,0,144,0,0,0,149,0,255,0,244,0,205,0,78,0,128,0,93,0,108,0,165,0,97,0,62,0,85,0,124,0,73,0,236,0,127,0,0,0,20,0,221,0,66,0,102,0,23,0,0,0,0,0,155,0,124,0,54,0,73,0,0,0,96,0,96,0,106,0,17,0,144,0,217,0,216,0,0,0,45,0,151,0,0,0,87,0,11,0,0,0,167,0,38,0,185,0,157,0,0,0,93,0,80,0,219,0,153,0,74,0,0,0,155,0,155,0,107,0,61,0,192,0,29,0,148,0,70,0,185,0,92,0,243,0,212,0,125,0,191,0,184,0,74,0,237,0,5,0,190,0,12,0,0,0,56,0,37,0,62,0,226,0,224,0,200,0,252,0,193,0,13,0,135,0,30,0,0,0,19,0,1,0,0,0,0,0,252,0,78,0,195,0,92,0,83,0,18,0,105,0,251,0,0,0,184,0,0,0,5,0,213,0,93,0,249,0,246,0,35,0,164,0,22,0,53,0,49,0,189,0,23,0,138,0,192,0,187,0,0,0,187,0,0,0,96,0,52,0,0,0,0,0,212,0,32,0,128,0,173,0,247,0,3,0,177,0,140,0,203,0,103,0,49,0,0,0,217,0,63,0,250,0,85,0,105,0,136,0,89,0,158,0,237,0,140,0,0,0,0,0,57,0,147,0,237,0,251,0,75,0,15,0,159,0,0,0,167,0,0,0,65,0,173,0,144,0,124,0,0,0,145,0,93,0,113,0,146,0,145,0,93,0,194,0,0,0,17,0,57,0,0,0,194,0,174,0,190,0,33,0,0,0,184,0,49,0,85,0,125,0,24,0,0,0,166,0,65,0,248,0,141,0,87,0,69,0,0,0,165,0,0,0,206,0,15,0,160,0,67,0,121,0,66,0,86,0,52,0,167,0,38,0,0,0,193,0,78,0,0,0,253,0,0,0,139,0,71,0,214,0,225,0,20,0,204,0,119,0,68,0,146,0,79,0,171,0,111,0,145,0,155,0,113,0,107,0,200,0,229,0,118,0,101,0,255,0,144,0,18,0,45,0,170,0,197,0,44,0,0,0,74,0,141,0,186,0,208,0,70,0,90,0,166,0,83,0,0,0,56,0,219,0,79,0,229,0,0,0,0,0,206,0,138,0,0,0,92,0,7,0,227,0,46,0,237,0,246,0,0,0,220,0,243,0,46,0,215,0,189,0,20,0,28,0,0,0,121,0,0,0,169,0,245,0,32,0,91,0,70,0,113,0,0,0,242,0,137,0,140,0,0,0,0,0,201,0,243,0,194,0,223,0,251,0,49,0,0,0,174,0,251,0,0,0,181,0,69,0,188,0,0,0,64,0,0,0,218,0,171,0,60,0,167,0,42,0,93,0,120,0,94,0,65,0,178,0,219,0,187,0,87,0,176,0,27,0,43,0,114,0,156,0,105,0,123,0,0,0,106,0,120,0,0,0,233,0,21,0,60,0,170,0,2,0,198,0,74,0,230,0,0,0,59,0,0,0,54,0,37,0,0,0,159,0,6,0,45,0,241,0,0,0,190,0,0,0,133,0,88,0,0,0,0,0,14,0,0,0,188,0,0,0,130,0,25,0,90,0,0,0,207,0,48,0,137,0,254,0,101,0,188,0,173,0,162,0,185,0,252,0,213,0,0,0,1,0,132,0,95,0,233,0,220,0,249,0,161,0,22,0,40,0,116,0,100,0,0,0,248,0,226,0,7,0,3,0,42,0,147,0,168,0,0,0,36,0,0,0,180,0,0,0,159,0,159,0,123,0,177,0,0,0,255,0,102,0,130,0,0,0,157,0,0,0);
signal scenario_full  : scenario_type := (57,31,70,31,7,31,105,31,105,30,30,31,194,31,10,31,10,30,183,31,111,31,111,30,8,31,158,31,158,30,247,31,247,30,46,31,3,31,56,31,56,30,188,31,76,31,76,30,76,29,243,31,248,31,195,31,105,31,206,31,40,31,40,30,66,31,46,31,11,31,11,30,191,31,236,31,107,31,107,30,126,31,36,31,149,31,246,31,158,31,149,31,148,31,205,31,205,30,205,29,205,28,147,31,147,30,10,31,170,31,95,31,95,30,250,31,250,30,2,31,133,31,39,31,98,31,98,30,210,31,187,31,187,30,88,31,88,30,236,31,158,31,241,31,241,30,143,31,185,31,228,31,228,30,69,31,115,31,159,31,159,30,84,31,84,30,76,31,173,31,163,31,161,31,209,31,251,31,5,31,2,31,190,31,190,30,190,29,251,31,106,31,106,30,212,31,212,30,68,31,74,31,74,30,74,29,174,31,130,31,100,31,100,30,72,31,72,30,63,31,202,31,169,31,144,31,91,31,223,31,214,31,50,31,150,31,220,31,244,31,251,31,39,31,33,31,114,31,172,31,80,31,80,30,6,31,17,31,161,31,178,31,159,31,159,30,35,31,35,30,22,31,22,30,78,31,78,30,23,31,148,31,41,31,168,31,228,31,228,30,228,29,51,31,51,30,167,31,167,30,167,29,7,31,7,30,170,31,223,31,16,31,24,31,246,31,102,31,193,31,43,31,253,31,253,30,132,31,91,31,175,31,170,31,186,31,23,31,91,31,222,31,222,30,227,31,77,31,29,31,41,31,135,31,196,31,192,31,203,31,118,31,171,31,43,31,27,31,223,31,253,31,182,31,113,31,232,31,163,31,29,31,140,31,239,31,239,30,42,31,89,31,96,31,96,30,109,31,109,30,62,31,250,31,80,31,80,30,80,29,63,31,34,31,34,30,34,29,205,31,102,31,253,31,159,31,122,31,122,30,168,31,47,31,113,31,7,31,140,31,103,31,65,31,92,31,90,31,90,30,204,31,94,31,55,31,20,31,82,31,82,30,116,31,60,31,171,31,24,31,118,31,177,31,90,31,163,31,217,31,47,31,47,30,75,31,124,31,123,31,53,31,67,31,90,31,33,31,68,31,68,30,68,29,94,31,94,30,166,31,166,30,166,29,195,31,12,31,12,30,72,31,21,31,14,31,14,30,23,31,23,30,23,29,85,31,173,31,11,31,38,31,38,30,75,31,237,31,117,31,117,30,117,29,131,31,42,31,208,31,40,31,255,31,127,31,146,31,104,31,143,31,193,31,160,31,125,31,127,31,112,31,112,30,98,31,87,31,13,31,177,31,32,31,122,31,221,31,221,30,221,29,124,31,157,31,157,30,137,31,137,30,230,31,91,31,91,30,180,31,160,31,147,31,146,31,119,31,119,30,119,29,167,31,167,30,153,31,40,31,250,31,178,31,101,31,117,31,68,31,175,31,23,31,9,31,9,30,9,29,20,31,196,31,46,31,40,31,33,31,147,31,63,31,116,31,116,30,249,31,210,31,41,31,66,31,23,31,161,31,68,31,140,31,118,31,213,31,213,30,93,31,139,31,230,31,189,31,61,31,155,31,155,30,79,31,226,31,226,30,77,31,91,31,99,31,99,30,1,31,1,30,1,29,215,31,121,31,253,31,155,31,97,31,49,31,17,31,17,30,45,31,45,30,33,31,33,30,33,29,237,31,237,30,144,31,144,30,149,31,255,31,244,31,205,31,78,31,128,31,93,31,108,31,165,31,97,31,62,31,85,31,124,31,73,31,236,31,127,31,127,30,20,31,221,31,66,31,102,31,23,31,23,30,23,29,155,31,124,31,54,31,73,31,73,30,96,31,96,31,106,31,17,31,144,31,217,31,216,31,216,30,45,31,151,31,151,30,87,31,11,31,11,30,167,31,38,31,185,31,157,31,157,30,93,31,80,31,219,31,153,31,74,31,74,30,155,31,155,31,107,31,61,31,192,31,29,31,148,31,70,31,185,31,92,31,243,31,212,31,125,31,191,31,184,31,74,31,237,31,5,31,190,31,12,31,12,30,56,31,37,31,62,31,226,31,224,31,200,31,252,31,193,31,13,31,135,31,30,31,30,30,19,31,1,31,1,30,1,29,252,31,78,31,195,31,92,31,83,31,18,31,105,31,251,31,251,30,184,31,184,30,5,31,213,31,93,31,249,31,246,31,35,31,164,31,22,31,53,31,49,31,189,31,23,31,138,31,192,31,187,31,187,30,187,31,187,30,96,31,52,31,52,30,52,29,212,31,32,31,128,31,173,31,247,31,3,31,177,31,140,31,203,31,103,31,49,31,49,30,217,31,63,31,250,31,85,31,105,31,136,31,89,31,158,31,237,31,140,31,140,30,140,29,57,31,147,31,237,31,251,31,75,31,15,31,159,31,159,30,167,31,167,30,65,31,173,31,144,31,124,31,124,30,145,31,93,31,113,31,146,31,145,31,93,31,194,31,194,30,17,31,57,31,57,30,194,31,174,31,190,31,33,31,33,30,184,31,49,31,85,31,125,31,24,31,24,30,166,31,65,31,248,31,141,31,87,31,69,31,69,30,165,31,165,30,206,31,15,31,160,31,67,31,121,31,66,31,86,31,52,31,167,31,38,31,38,30,193,31,78,31,78,30,253,31,253,30,139,31,71,31,214,31,225,31,20,31,204,31,119,31,68,31,146,31,79,31,171,31,111,31,145,31,155,31,113,31,107,31,200,31,229,31,118,31,101,31,255,31,144,31,18,31,45,31,170,31,197,31,44,31,44,30,74,31,141,31,186,31,208,31,70,31,90,31,166,31,83,31,83,30,56,31,219,31,79,31,229,31,229,30,229,29,206,31,138,31,138,30,92,31,7,31,227,31,46,31,237,31,246,31,246,30,220,31,243,31,46,31,215,31,189,31,20,31,28,31,28,30,121,31,121,30,169,31,245,31,32,31,91,31,70,31,113,31,113,30,242,31,137,31,140,31,140,30,140,29,201,31,243,31,194,31,223,31,251,31,49,31,49,30,174,31,251,31,251,30,181,31,69,31,188,31,188,30,64,31,64,30,218,31,171,31,60,31,167,31,42,31,93,31,120,31,94,31,65,31,178,31,219,31,187,31,87,31,176,31,27,31,43,31,114,31,156,31,105,31,123,31,123,30,106,31,120,31,120,30,233,31,21,31,60,31,170,31,2,31,198,31,74,31,230,31,230,30,59,31,59,30,54,31,37,31,37,30,159,31,6,31,45,31,241,31,241,30,190,31,190,30,133,31,88,31,88,30,88,29,14,31,14,30,188,31,188,30,130,31,25,31,90,31,90,30,207,31,48,31,137,31,254,31,101,31,188,31,173,31,162,31,185,31,252,31,213,31,213,30,1,31,132,31,95,31,233,31,220,31,249,31,161,31,22,31,40,31,116,31,100,31,100,30,248,31,226,31,7,31,3,31,42,31,147,31,168,31,168,30,36,31,36,30,180,31,180,30,159,31,159,31,123,31,177,31,177,30,255,31,102,31,130,31,130,30,157,31,157,30);

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
