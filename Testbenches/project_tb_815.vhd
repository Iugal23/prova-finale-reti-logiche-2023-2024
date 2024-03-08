-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_815 is
end project_tb_815;

architecture project_tb_arch_815 of project_tb_815 is
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

constant SCENARIO_LENGTH : integer := 157;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,75,0,230,0,245,0,0,0,84,0,150,0,85,0,42,0,84,0,74,0,0,0,192,0,139,0,219,0,210,0,206,0,0,0,0,0,144,0,180,0,193,0,15,0,55,0,237,0,220,0,241,0,91,0,157,0,43,0,0,0,249,0,185,0,118,0,29,0,170,0,182,0,0,0,10,0,254,0,84,0,174,0,8,0,234,0,67,0,42,0,53,0,183,0,0,0,35,0,235,0,114,0,123,0,0,0,86,0,82,0,73,0,187,0,80,0,66,0,115,0,108,0,79,0,237,0,14,0,97,0,0,0,0,0,254,0,133,0,0,0,0,0,187,0,80,0,0,0,150,0,89,0,53,0,0,0,68,0,88,0,28,0,140,0,210,0,87,0,97,0,131,0,172,0,100,0,0,0,116,0,126,0,0,0,0,0,15,0,92,0,217,0,239,0,50,0,54,0,162,0,248,0,60,0,30,0,114,0,59,0,235,0,181,0,215,0,41,0,125,0,0,0,9,0,128,0,247,0,30,0,81,0,84,0,25,0,71,0,205,0,0,0,199,0,0,0,206,0,81,0,87,0,44,0,201,0,0,0,4,0,0,0,31,0,60,0,9,0,18,0,230,0,121,0,0,0,0,0,168,0,32,0,223,0,65,0,28,0,224,0,154,0,0,0,0,0,63,0,154,0,251,0,21,0,0,0,122,0,239,0,229,0);
signal scenario_full  : scenario_type := (0,0,75,31,230,31,245,31,245,30,84,31,150,31,85,31,42,31,84,31,74,31,74,30,192,31,139,31,219,31,210,31,206,31,206,30,206,29,144,31,180,31,193,31,15,31,55,31,237,31,220,31,241,31,91,31,157,31,43,31,43,30,249,31,185,31,118,31,29,31,170,31,182,31,182,30,10,31,254,31,84,31,174,31,8,31,234,31,67,31,42,31,53,31,183,31,183,30,35,31,235,31,114,31,123,31,123,30,86,31,82,31,73,31,187,31,80,31,66,31,115,31,108,31,79,31,237,31,14,31,97,31,97,30,97,29,254,31,133,31,133,30,133,29,187,31,80,31,80,30,150,31,89,31,53,31,53,30,68,31,88,31,28,31,140,31,210,31,87,31,97,31,131,31,172,31,100,31,100,30,116,31,126,31,126,30,126,29,15,31,92,31,217,31,239,31,50,31,54,31,162,31,248,31,60,31,30,31,114,31,59,31,235,31,181,31,215,31,41,31,125,31,125,30,9,31,128,31,247,31,30,31,81,31,84,31,25,31,71,31,205,31,205,30,199,31,199,30,206,31,81,31,87,31,44,31,201,31,201,30,4,31,4,30,31,31,60,31,9,31,18,31,230,31,121,31,121,30,121,29,168,31,32,31,223,31,65,31,28,31,224,31,154,31,154,30,154,29,63,31,154,31,251,31,21,31,21,30,122,31,239,31,229,31);

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
