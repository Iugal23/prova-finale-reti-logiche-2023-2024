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

constant SCENARIO_LENGTH : integer := 530;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (196,0,0,0,199,0,190,0,178,0,92,0,183,0,12,0,61,0,252,0,6,0,219,0,0,0,217,0,235,0,97,0,134,0,0,0,133,0,169,0,40,0,207,0,253,0,157,0,169,0,0,0,74,0,18,0,138,0,241,0,0,0,241,0,0,0,26,0,195,0,118,0,202,0,0,0,70,0,136,0,144,0,132,0,171,0,169,0,41,0,144,0,59,0,153,0,19,0,0,0,88,0,92,0,238,0,195,0,108,0,102,0,124,0,0,0,73,0,186,0,127,0,133,0,193,0,55,0,115,0,0,0,0,0,111,0,68,0,0,0,132,0,119,0,60,0,175,0,26,0,4,0,211,0,194,0,121,0,73,0,20,0,191,0,192,0,206,0,196,0,118,0,165,0,153,0,0,0,137,0,0,0,81,0,79,0,147,0,0,0,50,0,49,0,70,0,195,0,137,0,0,0,138,0,113,0,53,0,217,0,35,0,0,0,18,0,151,0,127,0,10,0,2,0,0,0,98,0,41,0,147,0,122,0,57,0,136,0,116,0,0,0,82,0,139,0,160,0,0,0,45,0,0,0,168,0,0,0,0,0,9,0,0,0,239,0,77,0,125,0,146,0,0,0,0,0,7,0,186,0,0,0,158,0,0,0,96,0,51,0,186,0,28,0,0,0,120,0,0,0,238,0,169,0,126,0,184,0,179,0,11,0,60,0,0,0,89,0,111,0,174,0,253,0,13,0,164,0,159,0,145,0,156,0,204,0,0,0,9,0,145,0,148,0,163,0,128,0,0,0,131,0,0,0,155,0,66,0,174,0,0,0,180,0,28,0,16,0,240,0,184,0,207,0,65,0,143,0,225,0,18,0,221,0,116,0,204,0,187,0,0,0,233,0,115,0,0,0,0,0,0,0,2,0,68,0,126,0,190,0,73,0,205,0,59,0,163,0,199,0,0,0,119,0,0,0,26,0,198,0,0,0,170,0,0,0,0,0,159,0,93,0,171,0,144,0,254,0,251,0,214,0,34,0,82,0,246,0,160,0,199,0,123,0,19,0,158,0,150,0,0,0,97,0,104,0,72,0,0,0,90,0,145,0,0,0,0,0,0,0,177,0,0,0,134,0,29,0,253,0,23,0,0,0,112,0,70,0,186,0,146,0,116,0,0,0,255,0,130,0,213,0,167,0,219,0,232,0,0,0,22,0,118,0,111,0,0,0,253,0,145,0,157,0,255,0,91,0,227,0,94,0,218,0,157,0,0,0,57,0,0,0,108,0,38,0,0,0,213,0,95,0,52,0,12,0,112,0,151,0,197,0,0,0,22,0,47,0,47,0,55,0,198,0,0,0,101,0,213,0,0,0,121,0,0,0,195,0,122,0,45,0,201,0,174,0,187,0,0,0,242,0,80,0,0,0,0,0,58,0,112,0,111,0,42,0,0,0,59,0,179,0,192,0,183,0,89,0,129,0,241,0,253,0,190,0,0,0,241,0,228,0,162,0,9,0,0,0,214,0,207,0,126,0,87,0,240,0,110,0,198,0,82,0,218,0,65,0,213,0,6,0,104,0,79,0,117,0,0,0,0,0,0,0,25,0,0,0,231,0,170,0,212,0,249,0,124,0,140,0,0,0,0,0,58,0,146,0,0,0,183,0,96,0,119,0,0,0,0,0,12,0,0,0,206,0,0,0,111,0,35,0,0,0,152,0,0,0,119,0,129,0,228,0,0,0,254,0,129,0,246,0,218,0,32,0,20,0,0,0,148,0,12,0,0,0,173,0,168,0,176,0,85,0,0,0,114,0,170,0,0,0,118,0,245,0,0,0,28,0,55,0,174,0,185,0,0,0,78,0,151,0,157,0,127,0,160,0,97,0,221,0,0,0,139,0,33,0,155,0,141,0,223,0,52,0,230,0,161,0,76,0,0,0,222,0,104,0,108,0,5,0,0,0,8,0,138,0,67,0,252,0,0,0,56,0,202,0,243,0,140,0,242,0,63,0,155,0,88,0,185,0,69,0,129,0,69,0,26,0,231,0,0,0,120,0,177,0,244,0,48,0,0,0,232,0,0,0,0,0,152,0,0,0,0,0,182,0,100,0,9,0,198,0,199,0,110,0,126,0,0,0,96,0,0,0,119,0,174,0,76,0,199,0,107,0,43,0,0,0,87,0,128,0,0,0,0,0,193,0,36,0,237,0,123,0,201,0,52,0,171,0,137,0,42,0,156,0,0,0,146,0,30,0,16,0,226,0,0,0,110,0,168,0,187,0,88,0,193,0,0,0,49,0,0,0,84,0,5,0,224,0,238,0,185,0,67,0,0,0,231,0,0,0,0,0,0,0,0,0,19,0,31,0,0,0,0,0,0,0,100,0,6,0,163,0,180,0,211,0);
signal scenario_full  : scenario_type := (196,31,196,30,199,31,190,31,178,31,92,31,183,31,12,31,61,31,252,31,6,31,219,31,219,30,217,31,235,31,97,31,134,31,134,30,133,31,169,31,40,31,207,31,253,31,157,31,169,31,169,30,74,31,18,31,138,31,241,31,241,30,241,31,241,30,26,31,195,31,118,31,202,31,202,30,70,31,136,31,144,31,132,31,171,31,169,31,41,31,144,31,59,31,153,31,19,31,19,30,88,31,92,31,238,31,195,31,108,31,102,31,124,31,124,30,73,31,186,31,127,31,133,31,193,31,55,31,115,31,115,30,115,29,111,31,68,31,68,30,132,31,119,31,60,31,175,31,26,31,4,31,211,31,194,31,121,31,73,31,20,31,191,31,192,31,206,31,196,31,118,31,165,31,153,31,153,30,137,31,137,30,81,31,79,31,147,31,147,30,50,31,49,31,70,31,195,31,137,31,137,30,138,31,113,31,53,31,217,31,35,31,35,30,18,31,151,31,127,31,10,31,2,31,2,30,98,31,41,31,147,31,122,31,57,31,136,31,116,31,116,30,82,31,139,31,160,31,160,30,45,31,45,30,168,31,168,30,168,29,9,31,9,30,239,31,77,31,125,31,146,31,146,30,146,29,7,31,186,31,186,30,158,31,158,30,96,31,51,31,186,31,28,31,28,30,120,31,120,30,238,31,169,31,126,31,184,31,179,31,11,31,60,31,60,30,89,31,111,31,174,31,253,31,13,31,164,31,159,31,145,31,156,31,204,31,204,30,9,31,145,31,148,31,163,31,128,31,128,30,131,31,131,30,155,31,66,31,174,31,174,30,180,31,28,31,16,31,240,31,184,31,207,31,65,31,143,31,225,31,18,31,221,31,116,31,204,31,187,31,187,30,233,31,115,31,115,30,115,29,115,28,2,31,68,31,126,31,190,31,73,31,205,31,59,31,163,31,199,31,199,30,119,31,119,30,26,31,198,31,198,30,170,31,170,30,170,29,159,31,93,31,171,31,144,31,254,31,251,31,214,31,34,31,82,31,246,31,160,31,199,31,123,31,19,31,158,31,150,31,150,30,97,31,104,31,72,31,72,30,90,31,145,31,145,30,145,29,145,28,177,31,177,30,134,31,29,31,253,31,23,31,23,30,112,31,70,31,186,31,146,31,116,31,116,30,255,31,130,31,213,31,167,31,219,31,232,31,232,30,22,31,118,31,111,31,111,30,253,31,145,31,157,31,255,31,91,31,227,31,94,31,218,31,157,31,157,30,57,31,57,30,108,31,38,31,38,30,213,31,95,31,52,31,12,31,112,31,151,31,197,31,197,30,22,31,47,31,47,31,55,31,198,31,198,30,101,31,213,31,213,30,121,31,121,30,195,31,122,31,45,31,201,31,174,31,187,31,187,30,242,31,80,31,80,30,80,29,58,31,112,31,111,31,42,31,42,30,59,31,179,31,192,31,183,31,89,31,129,31,241,31,253,31,190,31,190,30,241,31,228,31,162,31,9,31,9,30,214,31,207,31,126,31,87,31,240,31,110,31,198,31,82,31,218,31,65,31,213,31,6,31,104,31,79,31,117,31,117,30,117,29,117,28,25,31,25,30,231,31,170,31,212,31,249,31,124,31,140,31,140,30,140,29,58,31,146,31,146,30,183,31,96,31,119,31,119,30,119,29,12,31,12,30,206,31,206,30,111,31,35,31,35,30,152,31,152,30,119,31,129,31,228,31,228,30,254,31,129,31,246,31,218,31,32,31,20,31,20,30,148,31,12,31,12,30,173,31,168,31,176,31,85,31,85,30,114,31,170,31,170,30,118,31,245,31,245,30,28,31,55,31,174,31,185,31,185,30,78,31,151,31,157,31,127,31,160,31,97,31,221,31,221,30,139,31,33,31,155,31,141,31,223,31,52,31,230,31,161,31,76,31,76,30,222,31,104,31,108,31,5,31,5,30,8,31,138,31,67,31,252,31,252,30,56,31,202,31,243,31,140,31,242,31,63,31,155,31,88,31,185,31,69,31,129,31,69,31,26,31,231,31,231,30,120,31,177,31,244,31,48,31,48,30,232,31,232,30,232,29,152,31,152,30,152,29,182,31,100,31,9,31,198,31,199,31,110,31,126,31,126,30,96,31,96,30,119,31,174,31,76,31,199,31,107,31,43,31,43,30,87,31,128,31,128,30,128,29,193,31,36,31,237,31,123,31,201,31,52,31,171,31,137,31,42,31,156,31,156,30,146,31,30,31,16,31,226,31,226,30,110,31,168,31,187,31,88,31,193,31,193,30,49,31,49,30,84,31,5,31,224,31,238,31,185,31,67,31,67,30,231,31,231,30,231,29,231,28,231,27,19,31,31,31,31,30,31,29,31,28,100,31,6,31,163,31,180,31,211,31);

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
