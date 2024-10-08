-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_690 is
end project_tb_690;

architecture project_tb_arch_690 of project_tb_690 is
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

constant SCENARIO_LENGTH : integer := 197;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (199,0,84,0,251,0,164,0,185,0,132,0,253,0,30,0,90,0,0,0,193,0,0,0,153,0,17,0,129,0,89,0,20,0,26,0,160,0,0,0,0,0,130,0,173,0,222,0,0,0,75,0,152,0,28,0,131,0,144,0,133,0,203,0,170,0,158,0,38,0,239,0,233,0,98,0,209,0,0,0,5,0,88,0,0,0,0,0,0,0,29,0,67,0,165,0,58,0,237,0,0,0,0,0,222,0,0,0,204,0,89,0,134,0,124,0,62,0,217,0,0,0,81,0,0,0,0,0,154,0,254,0,210,0,24,0,114,0,72,0,112,0,195,0,0,0,131,0,148,0,245,0,201,0,119,0,119,0,0,0,197,0,247,0,154,0,146,0,15,0,99,0,2,0,32,0,44,0,221,0,0,0,161,0,155,0,231,0,218,0,0,0,190,0,15,0,0,0,0,0,83,0,225,0,36,0,0,0,118,0,241,0,0,0,82,0,224,0,140,0,171,0,0,0,202,0,231,0,102,0,38,0,91,0,0,0,24,0,101,0,108,0,93,0,223,0,44,0,0,0,142,0,170,0,0,0,157,0,147,0,230,0,161,0,208,0,0,0,10,0,180,0,0,0,250,0,11,0,99,0,212,0,116,0,230,0,238,0,37,0,174,0,67,0,155,0,15,0,96,0,117,0,19,0,32,0,68,0,71,0,0,0,97,0,44,0,46,0,61,0,0,0,237,0,241,0,62,0,0,0,15,0,70,0,6,0,167,0,76,0,189,0,10,0,242,0,208,0,229,0,8,0,29,0,34,0,0,0,238,0,67,0,0,0,63,0,68,0,5,0,50,0,0,0,0,0,0,0,104,0,21,0,201,0,0,0,177,0,38,0,0,0,205,0);
signal scenario_full  : scenario_type := (199,31,84,31,251,31,164,31,185,31,132,31,253,31,30,31,90,31,90,30,193,31,193,30,153,31,17,31,129,31,89,31,20,31,26,31,160,31,160,30,160,29,130,31,173,31,222,31,222,30,75,31,152,31,28,31,131,31,144,31,133,31,203,31,170,31,158,31,38,31,239,31,233,31,98,31,209,31,209,30,5,31,88,31,88,30,88,29,88,28,29,31,67,31,165,31,58,31,237,31,237,30,237,29,222,31,222,30,204,31,89,31,134,31,124,31,62,31,217,31,217,30,81,31,81,30,81,29,154,31,254,31,210,31,24,31,114,31,72,31,112,31,195,31,195,30,131,31,148,31,245,31,201,31,119,31,119,31,119,30,197,31,247,31,154,31,146,31,15,31,99,31,2,31,32,31,44,31,221,31,221,30,161,31,155,31,231,31,218,31,218,30,190,31,15,31,15,30,15,29,83,31,225,31,36,31,36,30,118,31,241,31,241,30,82,31,224,31,140,31,171,31,171,30,202,31,231,31,102,31,38,31,91,31,91,30,24,31,101,31,108,31,93,31,223,31,44,31,44,30,142,31,170,31,170,30,157,31,147,31,230,31,161,31,208,31,208,30,10,31,180,31,180,30,250,31,11,31,99,31,212,31,116,31,230,31,238,31,37,31,174,31,67,31,155,31,15,31,96,31,117,31,19,31,32,31,68,31,71,31,71,30,97,31,44,31,46,31,61,31,61,30,237,31,241,31,62,31,62,30,15,31,70,31,6,31,167,31,76,31,189,31,10,31,242,31,208,31,229,31,8,31,29,31,34,31,34,30,238,31,67,31,67,30,63,31,68,31,5,31,50,31,50,30,50,29,50,28,104,31,21,31,201,31,201,30,177,31,38,31,38,30,205,31);

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
