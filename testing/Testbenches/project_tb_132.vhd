-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_132 is
end project_tb_132;

architecture project_tb_arch_132 of project_tb_132 is
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

constant SCENARIO_LENGTH : integer := 781;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (160,0,59,0,0,0,224,0,148,0,143,0,0,0,80,0,0,0,40,0,0,0,167,0,113,0,204,0,32,0,0,0,107,0,139,0,59,0,68,0,110,0,77,0,60,0,0,0,149,0,0,0,231,0,247,0,0,0,0,0,200,0,29,0,115,0,217,0,210,0,173,0,51,0,22,0,0,0,29,0,177,0,52,0,52,0,235,0,161,0,102,0,11,0,0,0,0,0,96,0,72,0,173,0,240,0,0,0,56,0,51,0,8,0,209,0,130,0,113,0,162,0,199,0,253,0,207,0,12,0,58,0,0,0,160,0,209,0,19,0,0,0,126,0,0,0,0,0,217,0,107,0,238,0,21,0,13,0,43,0,53,0,134,0,0,0,0,0,9,0,0,0,101,0,32,0,229,0,0,0,0,0,51,0,209,0,0,0,228,0,0,0,11,0,244,0,52,0,222,0,224,0,0,0,191,0,241,0,40,0,0,0,219,0,24,0,250,0,233,0,255,0,191,0,136,0,123,0,0,0,0,0,175,0,0,0,0,0,46,0,0,0,249,0,90,0,97,0,245,0,134,0,0,0,219,0,89,0,60,0,64,0,194,0,179,0,0,0,63,0,205,0,147,0,74,0,71,0,118,0,0,0,163,0,0,0,253,0,83,0,0,0,30,0,0,0,0,0,114,0,0,0,233,0,238,0,111,0,135,0,178,0,223,0,21,0,187,0,0,0,0,0,96,0,149,0,0,0,159,0,169,0,0,0,247,0,146,0,69,0,193,0,123,0,96,0,189,0,6,0,188,0,0,0,98,0,157,0,140,0,97,0,0,0,0,0,124,0,0,0,229,0,16,0,186,0,105,0,6,0,47,0,174,0,8,0,110,0,202,0,0,0,24,0,10,0,157,0,129,0,148,0,152,0,255,0,0,0,0,0,0,0,0,0,76,0,17,0,45,0,145,0,190,0,25,0,18,0,0,0,197,0,235,0,4,0,207,0,0,0,66,0,187,0,223,0,130,0,68,0,54,0,43,0,54,0,58,0,0,0,88,0,0,0,5,0,141,0,125,0,0,0,201,0,95,0,238,0,199,0,58,0,241,0,25,0,192,0,0,0,238,0,114,0,245,0,169,0,0,0,247,0,244,0,172,0,135,0,73,0,171,0,159,0,176,0,35,0,0,0,117,0,82,0,40,0,145,0,224,0,111,0,242,0,105,0,200,0,216,0,0,0,137,0,31,0,42,0,36,0,212,0,86,0,0,0,220,0,248,0,0,0,123,0,24,0,166,0,50,0,100,0,199,0,111,0,180,0,2,0,158,0,86,0,149,0,162,0,70,0,207,0,42,0,0,0,181,0,85,0,0,0,0,0,0,0,26,0,106,0,0,0,0,0,191,0,83,0,112,0,60,0,133,0,0,0,0,0,0,0,106,0,179,0,179,0,37,0,79,0,0,0,0,0,92,0,55,0,51,0,0,0,33,0,59,0,60,0,157,0,159,0,80,0,192,0,0,0,26,0,206,0,125,0,87,0,253,0,234,0,0,0,126,0,0,0,0,0,153,0,225,0,128,0,129,0,253,0,0,0,230,0,0,0,238,0,0,0,212,0,150,0,69,0,0,0,0,0,38,0,0,0,239,0,217,0,95,0,238,0,190,0,2,0,108,0,180,0,160,0,62,0,0,0,209,0,0,0,168,0,156,0,124,0,50,0,197,0,131,0,47,0,253,0,76,0,0,0,230,0,14,0,199,0,169,0,163,0,0,0,49,0,238,0,153,0,202,0,227,0,17,0,156,0,137,0,214,0,213,0,22,0,155,0,186,0,74,0,0,0,53,0,157,0,58,0,244,0,213,0,0,0,13,0,221,0,10,0,114,0,0,0,228,0,0,0,0,0,0,0,0,0,179,0,0,0,137,0,3,0,162,0,90,0,141,0,12,0,24,0,10,0,85,0,92,0,143,0,4,0,0,0,0,0,167,0,253,0,11,0,26,0,38,0,60,0,137,0,206,0,203,0,247,0,5,0,40,0,136,0,0,0,0,0,0,0,223,0,212,0,93,0,147,0,230,0,140,0,0,0,94,0,104,0,74,0,0,0,0,0,38,0,34,0,141,0,118,0,76,0,0,0,6,0,188,0,170,0,0,0,0,0,190,0,74,0,210,0,93,0,0,0,198,0,117,0,200,0,0,0,249,0,0,0,133,0,0,0,143,0,85,0,98,0,116,0,210,0,141,0,153,0,79,0,13,0,221,0,0,0,61,0,0,0,132,0,0,0,168,0,174,0,170,0,107,0,117,0,178,0,241,0,125,0,72,0,210,0,211,0,54,0,0,0,124,0,200,0,26,0,51,0,171,0,92,0,0,0,194,0,219,0,205,0,215,0,0,0,137,0,247,0,0,0,64,0,0,0,126,0,59,0,246,0,222,0,0,0,60,0,0,0,156,0,104,0,27,0,53,0,83,0,114,0,0,0,128,0,27,0,112,0,135,0,136,0,0,0,0,0,109,0,218,0,138,0,87,0,84,0,236,0,6,0,0,0,74,0,113,0,0,0,240,0,111,0,0,0,0,0,157,0,221,0,130,0,0,0,20,0,50,0,244,0,253,0,0,0,29,0,200,0,71,0,132,0,210,0,0,0,7,0,49,0,144,0,216,0,0,0,0,0,89,0,186,0,220,0,249,0,0,0,132,0,184,0,10,0,144,0,7,0,179,0,139,0,128,0,133,0,154,0,6,0,189,0,47,0,251,0,236,0,122,0,36,0,206,0,0,0,125,0,0,0,0,0,189,0,0,0,0,0,170,0,129,0,0,0,0,0,226,0,74,0,0,0,0,0,0,0,211,0,68,0,243,0,57,0,42,0,193,0,29,0,248,0,0,0,205,0,173,0,144,0,0,0,39,0,137,0,0,0,7,0,75,0,254,0,0,0,0,0,0,0,105,0,155,0,204,0,82,0,0,0,11,0,195,0,0,0,156,0,131,0,145,0,81,0,51,0,0,0,159,0,45,0,196,0,0,0,83,0,4,0,71,0,220,0,94,0,209,0,21,0,0,0,181,0,0,0,0,0,223,0,245,0,202,0,80,0,147,0,68,0,0,0,0,0,252,0,215,0,210,0,0,0,153,0,55,0,186,0,132,0,84,0,197,0,46,0,85,0,0,0,106,0,0,0,14,0,0,0,0,0,82,0,155,0,85,0,45,0,0,0,43,0,148,0,75,0,253,0,207,0,65,0,0,0,190,0,131,0,0,0,205,0,215,0,78,0,196,0,130,0,169,0,187,0,55,0,193,0,29,0,147,0,164,0,142,0,54,0,121,0,174,0,38,0,169,0,0,0,12,0,183,0,226,0,243,0,68,0,67,0,255,0,40,0,174,0,43,0,55,0,0,0,117,0,232,0,11,0,95,0,8,0,21,0,17,0,159,0,99,0,66,0,172,0,0,0,137,0,234,0,0,0,143,0,167,0,68,0,0,0,156,0,87,0,0,0,251,0,202,0,0,0,0,0,0,0,64,0);
signal scenario_full  : scenario_type := (160,31,59,31,59,30,224,31,148,31,143,31,143,30,80,31,80,30,40,31,40,30,167,31,113,31,204,31,32,31,32,30,107,31,139,31,59,31,68,31,110,31,77,31,60,31,60,30,149,31,149,30,231,31,247,31,247,30,247,29,200,31,29,31,115,31,217,31,210,31,173,31,51,31,22,31,22,30,29,31,177,31,52,31,52,31,235,31,161,31,102,31,11,31,11,30,11,29,96,31,72,31,173,31,240,31,240,30,56,31,51,31,8,31,209,31,130,31,113,31,162,31,199,31,253,31,207,31,12,31,58,31,58,30,160,31,209,31,19,31,19,30,126,31,126,30,126,29,217,31,107,31,238,31,21,31,13,31,43,31,53,31,134,31,134,30,134,29,9,31,9,30,101,31,32,31,229,31,229,30,229,29,51,31,209,31,209,30,228,31,228,30,11,31,244,31,52,31,222,31,224,31,224,30,191,31,241,31,40,31,40,30,219,31,24,31,250,31,233,31,255,31,191,31,136,31,123,31,123,30,123,29,175,31,175,30,175,29,46,31,46,30,249,31,90,31,97,31,245,31,134,31,134,30,219,31,89,31,60,31,64,31,194,31,179,31,179,30,63,31,205,31,147,31,74,31,71,31,118,31,118,30,163,31,163,30,253,31,83,31,83,30,30,31,30,30,30,29,114,31,114,30,233,31,238,31,111,31,135,31,178,31,223,31,21,31,187,31,187,30,187,29,96,31,149,31,149,30,159,31,169,31,169,30,247,31,146,31,69,31,193,31,123,31,96,31,189,31,6,31,188,31,188,30,98,31,157,31,140,31,97,31,97,30,97,29,124,31,124,30,229,31,16,31,186,31,105,31,6,31,47,31,174,31,8,31,110,31,202,31,202,30,24,31,10,31,157,31,129,31,148,31,152,31,255,31,255,30,255,29,255,28,255,27,76,31,17,31,45,31,145,31,190,31,25,31,18,31,18,30,197,31,235,31,4,31,207,31,207,30,66,31,187,31,223,31,130,31,68,31,54,31,43,31,54,31,58,31,58,30,88,31,88,30,5,31,141,31,125,31,125,30,201,31,95,31,238,31,199,31,58,31,241,31,25,31,192,31,192,30,238,31,114,31,245,31,169,31,169,30,247,31,244,31,172,31,135,31,73,31,171,31,159,31,176,31,35,31,35,30,117,31,82,31,40,31,145,31,224,31,111,31,242,31,105,31,200,31,216,31,216,30,137,31,31,31,42,31,36,31,212,31,86,31,86,30,220,31,248,31,248,30,123,31,24,31,166,31,50,31,100,31,199,31,111,31,180,31,2,31,158,31,86,31,149,31,162,31,70,31,207,31,42,31,42,30,181,31,85,31,85,30,85,29,85,28,26,31,106,31,106,30,106,29,191,31,83,31,112,31,60,31,133,31,133,30,133,29,133,28,106,31,179,31,179,31,37,31,79,31,79,30,79,29,92,31,55,31,51,31,51,30,33,31,59,31,60,31,157,31,159,31,80,31,192,31,192,30,26,31,206,31,125,31,87,31,253,31,234,31,234,30,126,31,126,30,126,29,153,31,225,31,128,31,129,31,253,31,253,30,230,31,230,30,238,31,238,30,212,31,150,31,69,31,69,30,69,29,38,31,38,30,239,31,217,31,95,31,238,31,190,31,2,31,108,31,180,31,160,31,62,31,62,30,209,31,209,30,168,31,156,31,124,31,50,31,197,31,131,31,47,31,253,31,76,31,76,30,230,31,14,31,199,31,169,31,163,31,163,30,49,31,238,31,153,31,202,31,227,31,17,31,156,31,137,31,214,31,213,31,22,31,155,31,186,31,74,31,74,30,53,31,157,31,58,31,244,31,213,31,213,30,13,31,221,31,10,31,114,31,114,30,228,31,228,30,228,29,228,28,228,27,179,31,179,30,137,31,3,31,162,31,90,31,141,31,12,31,24,31,10,31,85,31,92,31,143,31,4,31,4,30,4,29,167,31,253,31,11,31,26,31,38,31,60,31,137,31,206,31,203,31,247,31,5,31,40,31,136,31,136,30,136,29,136,28,223,31,212,31,93,31,147,31,230,31,140,31,140,30,94,31,104,31,74,31,74,30,74,29,38,31,34,31,141,31,118,31,76,31,76,30,6,31,188,31,170,31,170,30,170,29,190,31,74,31,210,31,93,31,93,30,198,31,117,31,200,31,200,30,249,31,249,30,133,31,133,30,143,31,85,31,98,31,116,31,210,31,141,31,153,31,79,31,13,31,221,31,221,30,61,31,61,30,132,31,132,30,168,31,174,31,170,31,107,31,117,31,178,31,241,31,125,31,72,31,210,31,211,31,54,31,54,30,124,31,200,31,26,31,51,31,171,31,92,31,92,30,194,31,219,31,205,31,215,31,215,30,137,31,247,31,247,30,64,31,64,30,126,31,59,31,246,31,222,31,222,30,60,31,60,30,156,31,104,31,27,31,53,31,83,31,114,31,114,30,128,31,27,31,112,31,135,31,136,31,136,30,136,29,109,31,218,31,138,31,87,31,84,31,236,31,6,31,6,30,74,31,113,31,113,30,240,31,111,31,111,30,111,29,157,31,221,31,130,31,130,30,20,31,50,31,244,31,253,31,253,30,29,31,200,31,71,31,132,31,210,31,210,30,7,31,49,31,144,31,216,31,216,30,216,29,89,31,186,31,220,31,249,31,249,30,132,31,184,31,10,31,144,31,7,31,179,31,139,31,128,31,133,31,154,31,6,31,189,31,47,31,251,31,236,31,122,31,36,31,206,31,206,30,125,31,125,30,125,29,189,31,189,30,189,29,170,31,129,31,129,30,129,29,226,31,74,31,74,30,74,29,74,28,211,31,68,31,243,31,57,31,42,31,193,31,29,31,248,31,248,30,205,31,173,31,144,31,144,30,39,31,137,31,137,30,7,31,75,31,254,31,254,30,254,29,254,28,105,31,155,31,204,31,82,31,82,30,11,31,195,31,195,30,156,31,131,31,145,31,81,31,51,31,51,30,159,31,45,31,196,31,196,30,83,31,4,31,71,31,220,31,94,31,209,31,21,31,21,30,181,31,181,30,181,29,223,31,245,31,202,31,80,31,147,31,68,31,68,30,68,29,252,31,215,31,210,31,210,30,153,31,55,31,186,31,132,31,84,31,197,31,46,31,85,31,85,30,106,31,106,30,14,31,14,30,14,29,82,31,155,31,85,31,45,31,45,30,43,31,148,31,75,31,253,31,207,31,65,31,65,30,190,31,131,31,131,30,205,31,215,31,78,31,196,31,130,31,169,31,187,31,55,31,193,31,29,31,147,31,164,31,142,31,54,31,121,31,174,31,38,31,169,31,169,30,12,31,183,31,226,31,243,31,68,31,67,31,255,31,40,31,174,31,43,31,55,31,55,30,117,31,232,31,11,31,95,31,8,31,21,31,17,31,159,31,99,31,66,31,172,31,172,30,137,31,234,31,234,30,143,31,167,31,68,31,68,30,156,31,87,31,87,30,251,31,202,31,202,30,202,29,202,28,64,31);

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
