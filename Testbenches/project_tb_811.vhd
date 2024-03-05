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

constant SCENARIO_LENGTH : integer := 153;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (244,0,0,0,134,0,6,0,231,0,102,0,227,0,57,0,224,0,224,0,126,0,14,0,181,0,0,0,220,0,104,0,234,0,40,0,239,0,156,0,56,0,193,0,150,0,140,0,165,0,196,0,116,0,55,0,255,0,185,0,200,0,9,0,1,0,173,0,58,0,44,0,3,0,232,0,97,0,180,0,233,0,143,0,189,0,104,0,43,0,239,0,127,0,145,0,0,0,162,0,43,0,116,0,229,0,0,0,50,0,75,0,241,0,138,0,50,0,161,0,249,0,100,0,207,0,208,0,0,0,127,0,0,0,52,0,161,0,0,0,118,0,80,0,167,0,8,0,94,0,54,0,181,0,0,0,174,0,199,0,44,0,77,0,107,0,0,0,253,0,87,0,210,0,0,0,76,0,179,0,149,0,184,0,100,0,252,0,48,0,227,0,129,0,0,0,11,0,155,0,244,0,245,0,129,0,134,0,0,0,18,0,207,0,208,0,73,0,214,0,168,0,6,0,97,0,0,0,0,0,183,0,129,0,188,0,0,0,60,0,168,0,57,0,58,0,0,0,0,0,159,0,0,0,152,0,78,0,100,0,245,0,94,0,101,0,241,0,243,0,0,0,4,0,1,0,117,0,172,0,28,0,60,0,97,0,252,0,209,0,145,0,0,0,122,0,0,0,129,0,175,0,232,0,198,0);
signal scenario_full  : scenario_type := (244,31,244,30,134,31,6,31,231,31,102,31,227,31,57,31,224,31,224,31,126,31,14,31,181,31,181,30,220,31,104,31,234,31,40,31,239,31,156,31,56,31,193,31,150,31,140,31,165,31,196,31,116,31,55,31,255,31,185,31,200,31,9,31,1,31,173,31,58,31,44,31,3,31,232,31,97,31,180,31,233,31,143,31,189,31,104,31,43,31,239,31,127,31,145,31,145,30,162,31,43,31,116,31,229,31,229,30,50,31,75,31,241,31,138,31,50,31,161,31,249,31,100,31,207,31,208,31,208,30,127,31,127,30,52,31,161,31,161,30,118,31,80,31,167,31,8,31,94,31,54,31,181,31,181,30,174,31,199,31,44,31,77,31,107,31,107,30,253,31,87,31,210,31,210,30,76,31,179,31,149,31,184,31,100,31,252,31,48,31,227,31,129,31,129,30,11,31,155,31,244,31,245,31,129,31,134,31,134,30,18,31,207,31,208,31,73,31,214,31,168,31,6,31,97,31,97,30,97,29,183,31,129,31,188,31,188,30,60,31,168,31,57,31,58,31,58,30,58,29,159,31,159,30,152,31,78,31,100,31,245,31,94,31,101,31,241,31,243,31,243,30,4,31,1,31,117,31,172,31,28,31,60,31,97,31,252,31,209,31,145,31,145,30,122,31,122,30,129,31,175,31,232,31,198,31);

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
