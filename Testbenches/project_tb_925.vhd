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

constant SCENARIO_LENGTH : integer := 759;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (240,0,12,0,0,0,0,0,251,0,0,0,240,0,240,0,134,0,86,0,67,0,0,0,0,0,1,0,232,0,249,0,121,0,228,0,51,0,0,0,113,0,0,0,0,0,104,0,209,0,204,0,149,0,30,0,133,0,90,0,114,0,0,0,95,0,0,0,34,0,63,0,171,0,144,0,248,0,228,0,91,0,3,0,252,0,148,0,0,0,233,0,0,0,243,0,0,0,169,0,0,0,14,0,211,0,229,0,0,0,85,0,222,0,0,0,118,0,134,0,18,0,0,0,32,0,3,0,215,0,11,0,0,0,35,0,78,0,226,0,2,0,8,0,60,0,39,0,0,0,207,0,241,0,19,0,201,0,21,0,13,0,219,0,204,0,197,0,39,0,149,0,86,0,173,0,109,0,146,0,0,0,248,0,219,0,0,0,147,0,5,0,0,0,17,0,34,0,182,0,0,0,26,0,0,0,147,0,146,0,22,0,0,0,0,0,84,0,12,0,180,0,0,0,94,0,0,0,164,0,0,0,146,0,42,0,128,0,24,0,87,0,0,0,189,0,94,0,100,0,65,0,213,0,196,0,43,0,212,0,35,0,46,0,196,0,134,0,0,0,15,0,0,0,148,0,192,0,0,0,168,0,255,0,98,0,163,0,131,0,134,0,0,0,111,0,214,0,174,0,0,0,58,0,117,0,225,0,17,0,100,0,189,0,0,0,5,0,0,0,90,0,171,0,0,0,237,0,2,0,8,0,143,0,44,0,172,0,251,0,0,0,1,0,237,0,82,0,206,0,42,0,137,0,153,0,233,0,139,0,239,0,0,0,171,0,0,0,0,0,74,0,247,0,0,0,183,0,154,0,210,0,74,0,176,0,140,0,7,0,220,0,159,0,54,0,92,0,145,0,49,0,198,0,9,0,24,0,0,0,56,0,220,0,52,0,141,0,84,0,177,0,35,0,209,0,234,0,103,0,179,0,222,0,139,0,0,0,57,0,68,0,121,0,244,0,226,0,165,0,157,0,78,0,98,0,117,0,0,0,209,0,200,0,185,0,8,0,166,0,48,0,55,0,237,0,181,0,0,0,62,0,156,0,252,0,195,0,0,0,141,0,49,0,80,0,0,0,60,0,0,0,0,0,8,0,111,0,0,0,90,0,0,0,23,0,169,0,0,0,120,0,180,0,8,0,64,0,122,0,184,0,67,0,185,0,0,0,130,0,251,0,237,0,194,0,196,0,107,0,244,0,0,0,0,0,0,0,0,0,243,0,80,0,0,0,209,0,214,0,104,0,139,0,213,0,80,0,0,0,191,0,131,0,242,0,213,0,152,0,107,0,18,0,55,0,243,0,197,0,98,0,219,0,232,0,64,0,108,0,0,0,201,0,103,0,139,0,155,0,103,0,214,0,253,0,81,0,231,0,178,0,239,0,231,0,242,0,0,0,15,0,184,0,0,0,120,0,145,0,78,0,111,0,0,0,238,0,173,0,175,0,0,0,0,0,0,0,60,0,15,0,235,0,234,0,33,0,39,0,89,0,177,0,0,0,18,0,199,0,161,0,0,0,10,0,156,0,0,0,0,0,41,0,115,0,29,0,62,0,52,0,0,0,145,0,66,0,76,0,0,0,246,0,245,0,68,0,132,0,48,0,60,0,102,0,176,0,120,0,0,0,101,0,182,0,56,0,7,0,170,0,150,0,157,0,221,0,78,0,0,0,0,0,0,0,94,0,84,0,247,0,235,0,106,0,54,0,121,0,37,0,67,0,22,0,146,0,22,0,246,0,213,0,8,0,109,0,0,0,0,0,52,0,149,0,23,0,0,0,82,0,141,0,50,0,70,0,221,0,0,0,43,0,0,0,246,0,151,0,82,0,11,0,95,0,55,0,92,0,25,0,10,0,108,0,26,0,221,0,204,0,104,0,97,0,0,0,202,0,79,0,13,0,61,0,204,0,113,0,56,0,21,0,84,0,31,0,0,0,14,0,230,0,125,0,229,0,11,0,239,0,123,0,107,0,186,0,73,0,39,0,36,0,30,0,15,0,37,0,0,0,221,0,189,0,117,0,59,0,133,0,182,0,115,0,125,0,105,0,159,0,53,0,160,0,0,0,245,0,0,0,0,0,240,0,98,0,89,0,0,0,0,0,177,0,9,0,9,0,148,0,79,0,60,0,233,0,174,0,252,0,0,0,0,0,166,0,135,0,109,0,44,0,30,0,0,0,21,0,169,0,130,0,50,0,189,0,163,0,67,0,210,0,37,0,193,0,84,0,230,0,61,0,1,0,6,0,253,0,0,0,213,0,109,0,111,0,229,0,72,0,224,0,157,0,82,0,161,0,91,0,44,0,203,0,0,0,0,0,46,0,106,0,0,0,106,0,0,0,109,0,16,0,0,0,5,0,4,0,0,0,117,0,169,0,0,0,103,0,109,0,17,0,0,0,44,0,109,0,0,0,184,0,213,0,0,0,163,0,170,0,0,0,165,0,0,0,70,0,137,0,232,0,157,0,249,0,35,0,238,0,154,0,199,0,0,0,0,0,219,0,218,0,250,0,163,0,29,0,0,0,176,0,5,0,250,0,0,0,64,0,0,0,165,0,50,0,82,0,51,0,225,0,97,0,33,0,174,0,238,0,0,0,102,0,164,0,0,0,0,0,0,0,173,0,0,0,7,0,18,0,52,0,62,0,113,0,105,0,151,0,97,0,13,0,12,0,209,0,141,0,192,0,0,0,218,0,101,0,219,0,0,0,0,0,65,0,0,0,240,0,44,0,0,0,99,0,35,0,210,0,49,0,121,0,0,0,240,0,231,0,0,0,173,0,245,0,253,0,54,0,204,0,226,0,226,0,143,0,170,0,0,0,117,0,178,0,123,0,192,0,241,0,194,0,171,0,197,0,167,0,100,0,45,0,0,0,218,0,196,0,85,0,81,0,64,0,233,0,60,0,0,0,0,0,0,0,61,0,209,0,0,0,107,0,2,0,235,0,101,0,94,0,206,0,46,0,52,0,0,0,143,0,52,0,213,0,212,0,175,0,0,0,13,0,186,0,231,0,0,0,0,0,84,0,164,0,48,0,0,0,179,0,0,0,248,0,210,0,75,0,0,0,209,0,0,0,13,0,248,0,197,0,214,0,25,0,0,0,20,0,99,0,85,0,154,0,0,0,178,0,34,0,0,0,105,0,170,0,217,0,0,0,71,0,90,0,98,0,28,0,98,0,0,0,0,0,62,0,42,0,150,0,248,0,0,0,49,0,237,0,0,0,48,0,150,0,14,0,244,0,105,0,234,0,198,0,0,0,168,0,0,0,60,0,198,0,16,0,69,0,0,0,0,0,166,0,5,0,185,0,30,0,65,0,225,0,61,0,108,0,114,0,217,0,34,0,154,0,0,0,119,0,0,0,8,0);
signal scenario_full  : scenario_type := (240,31,12,31,12,30,12,29,251,31,251,30,240,31,240,31,134,31,86,31,67,31,67,30,67,29,1,31,232,31,249,31,121,31,228,31,51,31,51,30,113,31,113,30,113,29,104,31,209,31,204,31,149,31,30,31,133,31,90,31,114,31,114,30,95,31,95,30,34,31,63,31,171,31,144,31,248,31,228,31,91,31,3,31,252,31,148,31,148,30,233,31,233,30,243,31,243,30,169,31,169,30,14,31,211,31,229,31,229,30,85,31,222,31,222,30,118,31,134,31,18,31,18,30,32,31,3,31,215,31,11,31,11,30,35,31,78,31,226,31,2,31,8,31,60,31,39,31,39,30,207,31,241,31,19,31,201,31,21,31,13,31,219,31,204,31,197,31,39,31,149,31,86,31,173,31,109,31,146,31,146,30,248,31,219,31,219,30,147,31,5,31,5,30,17,31,34,31,182,31,182,30,26,31,26,30,147,31,146,31,22,31,22,30,22,29,84,31,12,31,180,31,180,30,94,31,94,30,164,31,164,30,146,31,42,31,128,31,24,31,87,31,87,30,189,31,94,31,100,31,65,31,213,31,196,31,43,31,212,31,35,31,46,31,196,31,134,31,134,30,15,31,15,30,148,31,192,31,192,30,168,31,255,31,98,31,163,31,131,31,134,31,134,30,111,31,214,31,174,31,174,30,58,31,117,31,225,31,17,31,100,31,189,31,189,30,5,31,5,30,90,31,171,31,171,30,237,31,2,31,8,31,143,31,44,31,172,31,251,31,251,30,1,31,237,31,82,31,206,31,42,31,137,31,153,31,233,31,139,31,239,31,239,30,171,31,171,30,171,29,74,31,247,31,247,30,183,31,154,31,210,31,74,31,176,31,140,31,7,31,220,31,159,31,54,31,92,31,145,31,49,31,198,31,9,31,24,31,24,30,56,31,220,31,52,31,141,31,84,31,177,31,35,31,209,31,234,31,103,31,179,31,222,31,139,31,139,30,57,31,68,31,121,31,244,31,226,31,165,31,157,31,78,31,98,31,117,31,117,30,209,31,200,31,185,31,8,31,166,31,48,31,55,31,237,31,181,31,181,30,62,31,156,31,252,31,195,31,195,30,141,31,49,31,80,31,80,30,60,31,60,30,60,29,8,31,111,31,111,30,90,31,90,30,23,31,169,31,169,30,120,31,180,31,8,31,64,31,122,31,184,31,67,31,185,31,185,30,130,31,251,31,237,31,194,31,196,31,107,31,244,31,244,30,244,29,244,28,244,27,243,31,80,31,80,30,209,31,214,31,104,31,139,31,213,31,80,31,80,30,191,31,131,31,242,31,213,31,152,31,107,31,18,31,55,31,243,31,197,31,98,31,219,31,232,31,64,31,108,31,108,30,201,31,103,31,139,31,155,31,103,31,214,31,253,31,81,31,231,31,178,31,239,31,231,31,242,31,242,30,15,31,184,31,184,30,120,31,145,31,78,31,111,31,111,30,238,31,173,31,175,31,175,30,175,29,175,28,60,31,15,31,235,31,234,31,33,31,39,31,89,31,177,31,177,30,18,31,199,31,161,31,161,30,10,31,156,31,156,30,156,29,41,31,115,31,29,31,62,31,52,31,52,30,145,31,66,31,76,31,76,30,246,31,245,31,68,31,132,31,48,31,60,31,102,31,176,31,120,31,120,30,101,31,182,31,56,31,7,31,170,31,150,31,157,31,221,31,78,31,78,30,78,29,78,28,94,31,84,31,247,31,235,31,106,31,54,31,121,31,37,31,67,31,22,31,146,31,22,31,246,31,213,31,8,31,109,31,109,30,109,29,52,31,149,31,23,31,23,30,82,31,141,31,50,31,70,31,221,31,221,30,43,31,43,30,246,31,151,31,82,31,11,31,95,31,55,31,92,31,25,31,10,31,108,31,26,31,221,31,204,31,104,31,97,31,97,30,202,31,79,31,13,31,61,31,204,31,113,31,56,31,21,31,84,31,31,31,31,30,14,31,230,31,125,31,229,31,11,31,239,31,123,31,107,31,186,31,73,31,39,31,36,31,30,31,15,31,37,31,37,30,221,31,189,31,117,31,59,31,133,31,182,31,115,31,125,31,105,31,159,31,53,31,160,31,160,30,245,31,245,30,245,29,240,31,98,31,89,31,89,30,89,29,177,31,9,31,9,31,148,31,79,31,60,31,233,31,174,31,252,31,252,30,252,29,166,31,135,31,109,31,44,31,30,31,30,30,21,31,169,31,130,31,50,31,189,31,163,31,67,31,210,31,37,31,193,31,84,31,230,31,61,31,1,31,6,31,253,31,253,30,213,31,109,31,111,31,229,31,72,31,224,31,157,31,82,31,161,31,91,31,44,31,203,31,203,30,203,29,46,31,106,31,106,30,106,31,106,30,109,31,16,31,16,30,5,31,4,31,4,30,117,31,169,31,169,30,103,31,109,31,17,31,17,30,44,31,109,31,109,30,184,31,213,31,213,30,163,31,170,31,170,30,165,31,165,30,70,31,137,31,232,31,157,31,249,31,35,31,238,31,154,31,199,31,199,30,199,29,219,31,218,31,250,31,163,31,29,31,29,30,176,31,5,31,250,31,250,30,64,31,64,30,165,31,50,31,82,31,51,31,225,31,97,31,33,31,174,31,238,31,238,30,102,31,164,31,164,30,164,29,164,28,173,31,173,30,7,31,18,31,52,31,62,31,113,31,105,31,151,31,97,31,13,31,12,31,209,31,141,31,192,31,192,30,218,31,101,31,219,31,219,30,219,29,65,31,65,30,240,31,44,31,44,30,99,31,35,31,210,31,49,31,121,31,121,30,240,31,231,31,231,30,173,31,245,31,253,31,54,31,204,31,226,31,226,31,143,31,170,31,170,30,117,31,178,31,123,31,192,31,241,31,194,31,171,31,197,31,167,31,100,31,45,31,45,30,218,31,196,31,85,31,81,31,64,31,233,31,60,31,60,30,60,29,60,28,61,31,209,31,209,30,107,31,2,31,235,31,101,31,94,31,206,31,46,31,52,31,52,30,143,31,52,31,213,31,212,31,175,31,175,30,13,31,186,31,231,31,231,30,231,29,84,31,164,31,48,31,48,30,179,31,179,30,248,31,210,31,75,31,75,30,209,31,209,30,13,31,248,31,197,31,214,31,25,31,25,30,20,31,99,31,85,31,154,31,154,30,178,31,34,31,34,30,105,31,170,31,217,31,217,30,71,31,90,31,98,31,28,31,98,31,98,30,98,29,62,31,42,31,150,31,248,31,248,30,49,31,237,31,237,30,48,31,150,31,14,31,244,31,105,31,234,31,198,31,198,30,168,31,168,30,60,31,198,31,16,31,69,31,69,30,69,29,166,31,5,31,185,31,30,31,65,31,225,31,61,31,108,31,114,31,217,31,34,31,154,31,154,30,119,31,119,30,8,31);

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
