-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_938 is
end project_tb_938;

architecture project_tb_arch_938 of project_tb_938 is
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

constant SCENARIO_LENGTH : integer := 164;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,86,0,56,0,0,0,114,0,0,0,166,0,0,0,72,0,0,0,74,0,0,0,0,0,0,0,182,0,0,0,132,0,74,0,135,0,0,0,198,0,0,0,154,0,131,0,0,0,109,0,47,0,32,0,97,0,179,0,169,0,78,0,90,0,227,0,0,0,67,0,152,0,130,0,104,0,63,0,79,0,0,0,28,0,0,0,30,0,146,0,126,0,168,0,29,0,252,0,68,0,142,0,0,0,228,0,143,0,0,0,156,0,248,0,84,0,81,0,130,0,0,0,0,0,203,0,0,0,215,0,148,0,127,0,176,0,70,0,233,0,0,0,0,0,0,0,0,0,237,0,60,0,138,0,166,0,0,0,0,0,78,0,237,0,140,0,229,0,163,0,4,0,37,0,137,0,64,0,67,0,59,0,38,0,118,0,0,0,14,0,0,0,237,0,107,0,0,0,234,0,6,0,187,0,69,0,240,0,103,0,50,0,30,0,102,0,127,0,163,0,203,0,65,0,212,0,214,0,236,0,0,0,0,0,114,0,55,0,144,0,1,0,0,0,14,0,109,0,138,0,121,0,0,0,98,0,0,0,183,0,42,0,201,0,105,0,154,0,0,0,99,0,250,0,175,0,219,0,0,0,122,0,103,0,137,0,66,0,36,0,190,0,18,0,0,0,0,0,150,0,0,0,0,0,23,0,94,0,245,0,36,0,184,0,46,0,230,0,0,0,0,0,20,0,89,0);
signal scenario_full  : scenario_type := (0,0,86,31,56,31,56,30,114,31,114,30,166,31,166,30,72,31,72,30,74,31,74,30,74,29,74,28,182,31,182,30,132,31,74,31,135,31,135,30,198,31,198,30,154,31,131,31,131,30,109,31,47,31,32,31,97,31,179,31,169,31,78,31,90,31,227,31,227,30,67,31,152,31,130,31,104,31,63,31,79,31,79,30,28,31,28,30,30,31,146,31,126,31,168,31,29,31,252,31,68,31,142,31,142,30,228,31,143,31,143,30,156,31,248,31,84,31,81,31,130,31,130,30,130,29,203,31,203,30,215,31,148,31,127,31,176,31,70,31,233,31,233,30,233,29,233,28,233,27,237,31,60,31,138,31,166,31,166,30,166,29,78,31,237,31,140,31,229,31,163,31,4,31,37,31,137,31,64,31,67,31,59,31,38,31,118,31,118,30,14,31,14,30,237,31,107,31,107,30,234,31,6,31,187,31,69,31,240,31,103,31,50,31,30,31,102,31,127,31,163,31,203,31,65,31,212,31,214,31,236,31,236,30,236,29,114,31,55,31,144,31,1,31,1,30,14,31,109,31,138,31,121,31,121,30,98,31,98,30,183,31,42,31,201,31,105,31,154,31,154,30,99,31,250,31,175,31,219,31,219,30,122,31,103,31,137,31,66,31,36,31,190,31,18,31,18,30,18,29,150,31,150,30,150,29,23,31,94,31,245,31,36,31,184,31,46,31,230,31,230,30,230,29,20,31,89,31);

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
