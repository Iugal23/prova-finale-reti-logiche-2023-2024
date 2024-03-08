-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_988 is
end project_tb_988;

architecture project_tb_arch_988 of project_tb_988 is
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

constant SCENARIO_LENGTH : integer := 393;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,121,0,81,0,203,0,0,0,11,0,123,0,126,0,150,0,89,0,2,0,0,0,102,0,0,0,60,0,59,0,0,0,0,0,128,0,52,0,95,0,200,0,0,0,0,0,0,0,142,0,234,0,53,0,61,0,99,0,210,0,41,0,0,0,43,0,193,0,103,0,87,0,73,0,30,0,0,0,52,0,44,0,139,0,141,0,0,0,70,0,40,0,221,0,210,0,67,0,95,0,236,0,173,0,59,0,0,0,249,0,79,0,236,0,80,0,21,0,127,0,11,0,225,0,0,0,190,0,0,0,254,0,5,0,45,0,137,0,190,0,198,0,91,0,80,0,159,0,183,0,52,0,163,0,240,0,0,0,0,0,153,0,0,0,0,0,69,0,87,0,54,0,0,0,117,0,223,0,12,0,71,0,0,0,115,0,40,0,0,0,206,0,4,0,144,0,0,0,10,0,204,0,35,0,52,0,76,0,213,0,255,0,91,0,48,0,0,0,0,0,232,0,2,0,85,0,68,0,23,0,207,0,0,0,247,0,0,0,28,0,137,0,65,0,0,0,79,0,121,0,69,0,0,0,79,0,212,0,112,0,218,0,73,0,0,0,76,0,0,0,29,0,2,0,0,0,0,0,105,0,189,0,163,0,113,0,0,0,227,0,202,0,158,0,15,0,0,0,0,0,221,0,184,0,58,0,183,0,0,0,37,0,186,0,0,0,82,0,159,0,40,0,221,0,227,0,42,0,250,0,68,0,212,0,0,0,239,0,0,0,240,0,252,0,37,0,44,0,239,0,198,0,53,0,51,0,0,0,69,0,120,0,69,0,217,0,133,0,172,0,245,0,0,0,0,0,171,0,165,0,153,0,160,0,86,0,239,0,74,0,16,0,0,0,243,0,169,0,187,0,254,0,74,0,57,0,0,0,247,0,1,0,160,0,0,0,207,0,242,0,88,0,7,0,0,0,198,0,231,0,0,0,0,0,0,0,80,0,0,0,231,0,0,0,0,0,145,0,0,0,103,0,161,0,133,0,215,0,55,0,211,0,216,0,118,0,2,0,0,0,0,0,138,0,52,0,62,0,229,0,59,0,166,0,67,0,211,0,130,0,165,0,0,0,221,0,132,0,159,0,79,0,223,0,0,0,0,0,198,0,228,0,0,0,0,0,175,0,112,0,221,0,26,0,0,0,19,0,84,0,68,0,34,0,104,0,244,0,236,0,193,0,7,0,0,0,55,0,172,0,141,0,55,0,109,0,208,0,111,0,18,0,4,0,93,0,208,0,71,0,118,0,253,0,192,0,29,0,89,0,165,0,58,0,74,0,141,0,179,0,198,0,154,0,50,0,0,0,0,0,238,0,182,0,201,0,3,0,97,0,0,0,90,0,0,0,128,0,222,0,0,0,241,0,0,0,60,0,76,0,236,0,0,0,200,0,49,0,68,0,255,0,218,0,78,0,0,0,115,0,181,0,0,0,99,0,164,0,174,0,66,0,230,0,72,0,89,0,253,0,247,0,189,0,0,0,79,0,121,0,0,0,186,0,147,0,139,0,243,0,221,0,166,0,61,0,97,0,229,0,0,0,20,0,126,0,0,0,0,0,136,0,108,0,0,0,255,0,94,0,209,0,174,0,254,0,161,0,205,0,218,0,99,0,12,0,107,0,225,0,0,0,220,0,30,0,128,0,42,0,38,0,181,0,58,0,122,0,189,0,161,0,0,0,247,0,0,0,0,0,238,0,46,0,0,0,247,0,48,0,0,0,141,0);
signal scenario_full  : scenario_type := (0,0,121,31,81,31,203,31,203,30,11,31,123,31,126,31,150,31,89,31,2,31,2,30,102,31,102,30,60,31,59,31,59,30,59,29,128,31,52,31,95,31,200,31,200,30,200,29,200,28,142,31,234,31,53,31,61,31,99,31,210,31,41,31,41,30,43,31,193,31,103,31,87,31,73,31,30,31,30,30,52,31,44,31,139,31,141,31,141,30,70,31,40,31,221,31,210,31,67,31,95,31,236,31,173,31,59,31,59,30,249,31,79,31,236,31,80,31,21,31,127,31,11,31,225,31,225,30,190,31,190,30,254,31,5,31,45,31,137,31,190,31,198,31,91,31,80,31,159,31,183,31,52,31,163,31,240,31,240,30,240,29,153,31,153,30,153,29,69,31,87,31,54,31,54,30,117,31,223,31,12,31,71,31,71,30,115,31,40,31,40,30,206,31,4,31,144,31,144,30,10,31,204,31,35,31,52,31,76,31,213,31,255,31,91,31,48,31,48,30,48,29,232,31,2,31,85,31,68,31,23,31,207,31,207,30,247,31,247,30,28,31,137,31,65,31,65,30,79,31,121,31,69,31,69,30,79,31,212,31,112,31,218,31,73,31,73,30,76,31,76,30,29,31,2,31,2,30,2,29,105,31,189,31,163,31,113,31,113,30,227,31,202,31,158,31,15,31,15,30,15,29,221,31,184,31,58,31,183,31,183,30,37,31,186,31,186,30,82,31,159,31,40,31,221,31,227,31,42,31,250,31,68,31,212,31,212,30,239,31,239,30,240,31,252,31,37,31,44,31,239,31,198,31,53,31,51,31,51,30,69,31,120,31,69,31,217,31,133,31,172,31,245,31,245,30,245,29,171,31,165,31,153,31,160,31,86,31,239,31,74,31,16,31,16,30,243,31,169,31,187,31,254,31,74,31,57,31,57,30,247,31,1,31,160,31,160,30,207,31,242,31,88,31,7,31,7,30,198,31,231,31,231,30,231,29,231,28,80,31,80,30,231,31,231,30,231,29,145,31,145,30,103,31,161,31,133,31,215,31,55,31,211,31,216,31,118,31,2,31,2,30,2,29,138,31,52,31,62,31,229,31,59,31,166,31,67,31,211,31,130,31,165,31,165,30,221,31,132,31,159,31,79,31,223,31,223,30,223,29,198,31,228,31,228,30,228,29,175,31,112,31,221,31,26,31,26,30,19,31,84,31,68,31,34,31,104,31,244,31,236,31,193,31,7,31,7,30,55,31,172,31,141,31,55,31,109,31,208,31,111,31,18,31,4,31,93,31,208,31,71,31,118,31,253,31,192,31,29,31,89,31,165,31,58,31,74,31,141,31,179,31,198,31,154,31,50,31,50,30,50,29,238,31,182,31,201,31,3,31,97,31,97,30,90,31,90,30,128,31,222,31,222,30,241,31,241,30,60,31,76,31,236,31,236,30,200,31,49,31,68,31,255,31,218,31,78,31,78,30,115,31,181,31,181,30,99,31,164,31,174,31,66,31,230,31,72,31,89,31,253,31,247,31,189,31,189,30,79,31,121,31,121,30,186,31,147,31,139,31,243,31,221,31,166,31,61,31,97,31,229,31,229,30,20,31,126,31,126,30,126,29,136,31,108,31,108,30,255,31,94,31,209,31,174,31,254,31,161,31,205,31,218,31,99,31,12,31,107,31,225,31,225,30,220,31,30,31,128,31,42,31,38,31,181,31,58,31,122,31,189,31,161,31,161,30,247,31,247,30,247,29,238,31,46,31,46,30,247,31,48,31,48,30,141,31);

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
