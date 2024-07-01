-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_753 is
end project_tb_753;

architecture project_tb_arch_753 of project_tb_753 is
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

constant SCENARIO_LENGTH : integer := 245;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (116,0,30,0,108,0,7,0,198,0,33,0,37,0,0,0,191,0,0,0,0,0,159,0,45,0,139,0,95,0,0,0,0,0,78,0,29,0,28,0,151,0,0,0,152,0,193,0,35,0,160,0,138,0,143,0,93,0,0,0,175,0,89,0,204,0,20,0,0,0,197,0,244,0,0,0,205,0,0,0,220,0,224,0,0,0,116,0,13,0,0,0,0,0,12,0,23,0,226,0,2,0,147,0,0,0,249,0,0,0,0,0,0,0,101,0,0,0,114,0,47,0,26,0,0,0,152,0,238,0,0,0,154,0,146,0,0,0,209,0,183,0,195,0,13,0,0,0,126,0,110,0,14,0,199,0,105,0,169,0,220,0,48,0,15,0,0,0,0,0,229,0,202,0,63,0,93,0,73,0,0,0,113,0,173,0,51,0,221,0,172,0,55,0,0,0,67,0,212,0,35,0,194,0,231,0,28,0,0,0,177,0,126,0,0,0,149,0,12,0,191,0,228,0,0,0,98,0,189,0,68,0,0,0,0,0,0,0,10,0,199,0,89,0,23,0,30,0,151,0,194,0,97,0,187,0,0,0,108,0,73,0,7,0,142,0,216,0,118,0,218,0,172,0,98,0,228,0,249,0,135,0,27,0,135,0,137,0,99,0,21,0,0,0,45,0,131,0,0,0,164,0,163,0,125,0,36,0,120,0,251,0,154,0,131,0,248,0,90,0,21,0,146,0,6,0,221,0,92,0,161,0,102,0,32,0,131,0,19,0,201,0,179,0,154,0,129,0,206,0,0,0,251,0,0,0,221,0,155,0,64,0,0,0,35,0,165,0,246,0,71,0,127,0,133,0,200,0,29,0,0,0,8,0,0,0,192,0,245,0,82,0,171,0,234,0,128,0,146,0,49,0,155,0,189,0,240,0,251,0,142,0,119,0,0,0,0,0,160,0,223,0,158,0,117,0,239,0,136,0,19,0,128,0,52,0,170,0,98,0,225,0,0,0,0,0,165,0,0,0,0,0,102,0,121,0,220,0,114,0,245,0,236,0,149,0,243,0,0,0,53,0,131,0,246,0,107,0,14,0,0,0,46,0,5,0,30,0,139,0);
signal scenario_full  : scenario_type := (116,31,30,31,108,31,7,31,198,31,33,31,37,31,37,30,191,31,191,30,191,29,159,31,45,31,139,31,95,31,95,30,95,29,78,31,29,31,28,31,151,31,151,30,152,31,193,31,35,31,160,31,138,31,143,31,93,31,93,30,175,31,89,31,204,31,20,31,20,30,197,31,244,31,244,30,205,31,205,30,220,31,224,31,224,30,116,31,13,31,13,30,13,29,12,31,23,31,226,31,2,31,147,31,147,30,249,31,249,30,249,29,249,28,101,31,101,30,114,31,47,31,26,31,26,30,152,31,238,31,238,30,154,31,146,31,146,30,209,31,183,31,195,31,13,31,13,30,126,31,110,31,14,31,199,31,105,31,169,31,220,31,48,31,15,31,15,30,15,29,229,31,202,31,63,31,93,31,73,31,73,30,113,31,173,31,51,31,221,31,172,31,55,31,55,30,67,31,212,31,35,31,194,31,231,31,28,31,28,30,177,31,126,31,126,30,149,31,12,31,191,31,228,31,228,30,98,31,189,31,68,31,68,30,68,29,68,28,10,31,199,31,89,31,23,31,30,31,151,31,194,31,97,31,187,31,187,30,108,31,73,31,7,31,142,31,216,31,118,31,218,31,172,31,98,31,228,31,249,31,135,31,27,31,135,31,137,31,99,31,21,31,21,30,45,31,131,31,131,30,164,31,163,31,125,31,36,31,120,31,251,31,154,31,131,31,248,31,90,31,21,31,146,31,6,31,221,31,92,31,161,31,102,31,32,31,131,31,19,31,201,31,179,31,154,31,129,31,206,31,206,30,251,31,251,30,221,31,155,31,64,31,64,30,35,31,165,31,246,31,71,31,127,31,133,31,200,31,29,31,29,30,8,31,8,30,192,31,245,31,82,31,171,31,234,31,128,31,146,31,49,31,155,31,189,31,240,31,251,31,142,31,119,31,119,30,119,29,160,31,223,31,158,31,117,31,239,31,136,31,19,31,128,31,52,31,170,31,98,31,225,31,225,30,225,29,165,31,165,30,165,29,102,31,121,31,220,31,114,31,245,31,236,31,149,31,243,31,243,30,53,31,131,31,246,31,107,31,14,31,14,30,46,31,5,31,30,31,139,31);

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
