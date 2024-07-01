-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_162 is
end project_tb_162;

architecture project_tb_arch_162 of project_tb_162 is
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

constant SCENARIO_LENGTH : integer := 266;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (117,0,58,0,192,0,0,0,11,0,0,0,84,0,187,0,6,0,68,0,212,0,0,0,0,0,92,0,57,0,212,0,165,0,0,0,54,0,37,0,153,0,0,0,0,0,254,0,67,0,38,0,53,0,120,0,56,0,24,0,168,0,51,0,70,0,208,0,0,0,0,0,156,0,0,0,8,0,141,0,0,0,202,0,0,0,35,0,198,0,44,0,214,0,25,0,62,0,217,0,0,0,157,0,153,0,0,0,0,0,97,0,160,0,0,0,203,0,36,0,48,0,141,0,151,0,155,0,0,0,219,0,0,0,22,0,82,0,135,0,214,0,105,0,18,0,152,0,249,0,0,0,182,0,0,0,185,0,101,0,214,0,56,0,161,0,0,0,178,0,33,0,99,0,0,0,233,0,0,0,179,0,0,0,198,0,62,0,78,0,171,0,0,0,193,0,108,0,0,0,0,0,144,0,149,0,128,0,149,0,178,0,188,0,65,0,54,0,9,0,136,0,112,0,226,0,223,0,172,0,51,0,252,0,0,0,153,0,233,0,34,0,160,0,89,0,68,0,80,0,124,0,0,0,21,0,18,0,0,0,0,0,0,0,91,0,86,0,200,0,140,0,125,0,115,0,0,0,48,0,70,0,0,0,0,0,241,0,0,0,199,0,99,0,98,0,191,0,199,0,62,0,254,0,0,0,88,0,191,0,132,0,24,0,150,0,48,0,231,0,214,0,0,0,250,0,199,0,215,0,61,0,0,0,146,0,0,0,225,0,70,0,11,0,114,0,148,0,244,0,127,0,0,0,0,0,143,0,128,0,0,0,63,0,154,0,78,0,238,0,186,0,204,0,72,0,159,0,74,0,86,0,0,0,61,0,0,0,118,0,0,0,239,0,118,0,75,0,46,0,39,0,234,0,0,0,0,0,88,0,106,0,0,0,141,0,31,0,129,0,0,0,104,0,196,0,61,0,13,0,30,0,224,0,236,0,0,0,128,0,60,0,0,0,230,0,30,0,0,0,0,0,228,0,58,0,134,0,56,0,50,0,173,0,160,0,18,0,19,0,143,0,160,0,46,0,227,0,176,0,29,0,151,0,242,0,134,0,57,0,119,0,121,0,124,0,0,0,0,0,237,0,168,0,19,0,207,0,155,0,104,0,162,0,145,0,115,0,118,0,69,0,12,0,0,0,79,0,126,0,144,0);
signal scenario_full  : scenario_type := (117,31,58,31,192,31,192,30,11,31,11,30,84,31,187,31,6,31,68,31,212,31,212,30,212,29,92,31,57,31,212,31,165,31,165,30,54,31,37,31,153,31,153,30,153,29,254,31,67,31,38,31,53,31,120,31,56,31,24,31,168,31,51,31,70,31,208,31,208,30,208,29,156,31,156,30,8,31,141,31,141,30,202,31,202,30,35,31,198,31,44,31,214,31,25,31,62,31,217,31,217,30,157,31,153,31,153,30,153,29,97,31,160,31,160,30,203,31,36,31,48,31,141,31,151,31,155,31,155,30,219,31,219,30,22,31,82,31,135,31,214,31,105,31,18,31,152,31,249,31,249,30,182,31,182,30,185,31,101,31,214,31,56,31,161,31,161,30,178,31,33,31,99,31,99,30,233,31,233,30,179,31,179,30,198,31,62,31,78,31,171,31,171,30,193,31,108,31,108,30,108,29,144,31,149,31,128,31,149,31,178,31,188,31,65,31,54,31,9,31,136,31,112,31,226,31,223,31,172,31,51,31,252,31,252,30,153,31,233,31,34,31,160,31,89,31,68,31,80,31,124,31,124,30,21,31,18,31,18,30,18,29,18,28,91,31,86,31,200,31,140,31,125,31,115,31,115,30,48,31,70,31,70,30,70,29,241,31,241,30,199,31,99,31,98,31,191,31,199,31,62,31,254,31,254,30,88,31,191,31,132,31,24,31,150,31,48,31,231,31,214,31,214,30,250,31,199,31,215,31,61,31,61,30,146,31,146,30,225,31,70,31,11,31,114,31,148,31,244,31,127,31,127,30,127,29,143,31,128,31,128,30,63,31,154,31,78,31,238,31,186,31,204,31,72,31,159,31,74,31,86,31,86,30,61,31,61,30,118,31,118,30,239,31,118,31,75,31,46,31,39,31,234,31,234,30,234,29,88,31,106,31,106,30,141,31,31,31,129,31,129,30,104,31,196,31,61,31,13,31,30,31,224,31,236,31,236,30,128,31,60,31,60,30,230,31,30,31,30,30,30,29,228,31,58,31,134,31,56,31,50,31,173,31,160,31,18,31,19,31,143,31,160,31,46,31,227,31,176,31,29,31,151,31,242,31,134,31,57,31,119,31,121,31,124,31,124,30,124,29,237,31,168,31,19,31,207,31,155,31,104,31,162,31,145,31,115,31,118,31,69,31,12,31,12,30,79,31,126,31,144,31);

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
