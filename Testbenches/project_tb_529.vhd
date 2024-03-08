-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_529 is
end project_tb_529;

architecture project_tb_arch_529 of project_tb_529 is
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

signal scenario_input : scenario_type := (164,0,116,0,0,0,244,0,235,0,173,0,0,0,77,0,0,0,78,0,89,0,149,0,215,0,33,0,236,0,0,0,23,0,124,0,135,0,156,0,193,0,184,0,210,0,232,0,119,0,225,0,103,0,0,0,196,0,210,0,229,0,241,0,11,0,5,0,0,0,221,0,192,0,255,0,157,0,241,0,252,0,92,0,252,0,106,0,54,0,120,0,86,0,249,0,204,0,99,0,93,0,0,0,110,0,0,0,0,0,108,0,72,0,82,0,217,0,0,0,26,0,178,0,110,0,0,0,178,0,16,0,109,0,134,0,0,0,143,0,26,0,52,0,123,0,175,0,73,0,220,0,172,0,60,0,101,0,13,0,5,0,63,0,224,0,49,0,14,0,162,0,67,0,198,0,0,0,150,0,50,0,219,0,0,0,12,0,162,0,26,0,193,0,236,0,44,0,114,0,212,0,252,0,232,0,140,0,44,0,13,0,22,0,171,0,219,0,41,0,217,0,15,0,94,0,44,0,0,0,118,0,213,0,0,0,0,0,0,0,221,0,95,0,205,0,196,0,19,0,188,0,244,0,153,0,0,0,89,0,10,0,8,0,189,0,87,0,159,0,236,0,118,0,84,0,179,0,195,0,141,0,132,0,0,0,95,0,38,0,13,0,119,0,250,0,0,0,0,0,0,0,226,0,232,0,87,0,201,0,211,0,119,0,175,0,184,0,199,0,207,0,199,0,104,0,161,0);
signal scenario_full  : scenario_type := (164,31,116,31,116,30,244,31,235,31,173,31,173,30,77,31,77,30,78,31,89,31,149,31,215,31,33,31,236,31,236,30,23,31,124,31,135,31,156,31,193,31,184,31,210,31,232,31,119,31,225,31,103,31,103,30,196,31,210,31,229,31,241,31,11,31,5,31,5,30,221,31,192,31,255,31,157,31,241,31,252,31,92,31,252,31,106,31,54,31,120,31,86,31,249,31,204,31,99,31,93,31,93,30,110,31,110,30,110,29,108,31,72,31,82,31,217,31,217,30,26,31,178,31,110,31,110,30,178,31,16,31,109,31,134,31,134,30,143,31,26,31,52,31,123,31,175,31,73,31,220,31,172,31,60,31,101,31,13,31,5,31,63,31,224,31,49,31,14,31,162,31,67,31,198,31,198,30,150,31,50,31,219,31,219,30,12,31,162,31,26,31,193,31,236,31,44,31,114,31,212,31,252,31,232,31,140,31,44,31,13,31,22,31,171,31,219,31,41,31,217,31,15,31,94,31,44,31,44,30,118,31,213,31,213,30,213,29,213,28,221,31,95,31,205,31,196,31,19,31,188,31,244,31,153,31,153,30,89,31,10,31,8,31,189,31,87,31,159,31,236,31,118,31,84,31,179,31,195,31,141,31,132,31,132,30,95,31,38,31,13,31,119,31,250,31,250,30,250,29,250,28,226,31,232,31,87,31,201,31,211,31,119,31,175,31,184,31,199,31,207,31,199,31,104,31,161,31);

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
