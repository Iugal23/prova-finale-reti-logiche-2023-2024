-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_728 is
end project_tb_728;

architecture project_tb_arch_728 of project_tb_728 is
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

constant SCENARIO_LENGTH : integer := 206;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (61,0,0,0,95,0,63,0,84,0,188,0,205,0,232,0,188,0,87,0,0,0,242,0,31,0,129,0,0,0,4,0,0,0,164,0,0,0,152,0,0,0,224,0,37,0,134,0,204,0,80,0,252,0,0,0,0,0,99,0,108,0,127,0,221,0,86,0,53,0,188,0,96,0,0,0,33,0,3,0,70,0,215,0,178,0,88,0,0,0,77,0,67,0,32,0,155,0,101,0,81,0,216,0,0,0,28,0,0,0,0,0,151,0,31,0,242,0,0,0,0,0,159,0,131,0,64,0,53,0,1,0,0,0,17,0,156,0,0,0,190,0,189,0,150,0,196,0,0,0,0,0,0,0,62,0,130,0,24,0,244,0,63,0,159,0,72,0,141,0,0,0,199,0,0,0,0,0,65,0,236,0,235,0,10,0,36,0,98,0,108,0,221,0,0,0,0,0,13,0,158,0,0,0,98,0,0,0,199,0,57,0,132,0,0,0,63,0,122,0,241,0,54,0,0,0,0,0,195,0,0,0,122,0,225,0,128,0,0,0,55,0,0,0,110,0,139,0,0,0,0,0,89,0,0,0,80,0,5,0,0,0,0,0,205,0,92,0,0,0,0,0,0,0,195,0,237,0,254,0,144,0,97,0,129,0,0,0,180,0,93,0,186,0,132,0,119,0,121,0,209,0,0,0,0,0,231,0,124,0,231,0,0,0,94,0,180,0,0,0,125,0,64,0,142,0,103,0,251,0,25,0,197,0,58,0,140,0,82,0,57,0,0,0,5,0,193,0,151,0,230,0,98,0,0,0,74,0,233,0,0,0,226,0,119,0,34,0,0,0,220,0,229,0,0,0,224,0,0,0,212,0,12,0,159,0,0,0,53,0,0,0,226,0,8,0,0,0,25,0,0,0,0,0,111,0,148,0,64,0,175,0);
signal scenario_full  : scenario_type := (61,31,61,30,95,31,63,31,84,31,188,31,205,31,232,31,188,31,87,31,87,30,242,31,31,31,129,31,129,30,4,31,4,30,164,31,164,30,152,31,152,30,224,31,37,31,134,31,204,31,80,31,252,31,252,30,252,29,99,31,108,31,127,31,221,31,86,31,53,31,188,31,96,31,96,30,33,31,3,31,70,31,215,31,178,31,88,31,88,30,77,31,67,31,32,31,155,31,101,31,81,31,216,31,216,30,28,31,28,30,28,29,151,31,31,31,242,31,242,30,242,29,159,31,131,31,64,31,53,31,1,31,1,30,17,31,156,31,156,30,190,31,189,31,150,31,196,31,196,30,196,29,196,28,62,31,130,31,24,31,244,31,63,31,159,31,72,31,141,31,141,30,199,31,199,30,199,29,65,31,236,31,235,31,10,31,36,31,98,31,108,31,221,31,221,30,221,29,13,31,158,31,158,30,98,31,98,30,199,31,57,31,132,31,132,30,63,31,122,31,241,31,54,31,54,30,54,29,195,31,195,30,122,31,225,31,128,31,128,30,55,31,55,30,110,31,139,31,139,30,139,29,89,31,89,30,80,31,5,31,5,30,5,29,205,31,92,31,92,30,92,29,92,28,195,31,237,31,254,31,144,31,97,31,129,31,129,30,180,31,93,31,186,31,132,31,119,31,121,31,209,31,209,30,209,29,231,31,124,31,231,31,231,30,94,31,180,31,180,30,125,31,64,31,142,31,103,31,251,31,25,31,197,31,58,31,140,31,82,31,57,31,57,30,5,31,193,31,151,31,230,31,98,31,98,30,74,31,233,31,233,30,226,31,119,31,34,31,34,30,220,31,229,31,229,30,224,31,224,30,212,31,12,31,159,31,159,30,53,31,53,30,226,31,8,31,8,30,25,31,25,30,25,29,111,31,148,31,64,31,175,31);

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
