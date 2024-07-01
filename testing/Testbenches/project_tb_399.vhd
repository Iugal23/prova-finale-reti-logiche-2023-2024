-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_399 is
end project_tb_399;

architecture project_tb_arch_399 of project_tb_399 is
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

constant SCENARIO_LENGTH : integer := 228;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (146,0,186,0,80,0,0,0,122,0,169,0,0,0,27,0,93,0,0,0,225,0,0,0,0,0,194,0,0,0,17,0,87,0,71,0,0,0,22,0,83,0,233,0,82,0,99,0,83,0,41,0,147,0,170,0,0,0,211,0,39,0,0,0,18,0,159,0,90,0,154,0,126,0,167,0,43,0,173,0,77,0,159,0,50,0,107,0,22,0,40,0,165,0,208,0,175,0,236,0,225,0,96,0,21,0,2,0,183,0,178,0,0,0,255,0,0,0,229,0,125,0,217,0,0,0,159,0,162,0,245,0,176,0,89,0,49,0,33,0,137,0,0,0,207,0,67,0,94,0,59,0,147,0,110,0,165,0,177,0,80,0,67,0,29,0,0,0,189,0,99,0,178,0,123,0,0,0,214,0,15,0,0,0,196,0,6,0,147,0,158,0,21,0,216,0,13,0,197,0,181,0,12,0,151,0,0,0,0,0,156,0,157,0,138,0,0,0,0,0,0,0,235,0,83,0,255,0,0,0,0,0,91,0,0,0,168,0,211,0,0,0,0,0,168,0,102,0,192,0,243,0,154,0,23,0,36,0,252,0,0,0,7,0,179,0,255,0,62,0,249,0,37,0,117,0,196,0,97,0,176,0,12,0,0,0,227,0,0,0,174,0,155,0,78,0,12,0,234,0,234,0,75,0,69,0,135,0,22,0,51,0,207,0,164,0,78,0,0,0,249,0,0,0,211,0,0,0,0,0,0,0,214,0,52,0,195,0,27,0,88,0,0,0,54,0,0,0,98,0,137,0,211,0,80,0,49,0,0,0,0,0,0,0,120,0,0,0,153,0,66,0,250,0,50,0,0,0,159,0,0,0,247,0,188,0,0,0,0,0,173,0,59,0,33,0,146,0,250,0,70,0,190,0,33,0,145,0,131,0,82,0,133,0,128,0,157,0,185,0,39,0,188,0,98,0,195,0,35,0,227,0,214,0,255,0,227,0,204,0,77,0,216,0,246,0,92,0,0,0,92,0,130,0,88,0);
signal scenario_full  : scenario_type := (146,31,186,31,80,31,80,30,122,31,169,31,169,30,27,31,93,31,93,30,225,31,225,30,225,29,194,31,194,30,17,31,87,31,71,31,71,30,22,31,83,31,233,31,82,31,99,31,83,31,41,31,147,31,170,31,170,30,211,31,39,31,39,30,18,31,159,31,90,31,154,31,126,31,167,31,43,31,173,31,77,31,159,31,50,31,107,31,22,31,40,31,165,31,208,31,175,31,236,31,225,31,96,31,21,31,2,31,183,31,178,31,178,30,255,31,255,30,229,31,125,31,217,31,217,30,159,31,162,31,245,31,176,31,89,31,49,31,33,31,137,31,137,30,207,31,67,31,94,31,59,31,147,31,110,31,165,31,177,31,80,31,67,31,29,31,29,30,189,31,99,31,178,31,123,31,123,30,214,31,15,31,15,30,196,31,6,31,147,31,158,31,21,31,216,31,13,31,197,31,181,31,12,31,151,31,151,30,151,29,156,31,157,31,138,31,138,30,138,29,138,28,235,31,83,31,255,31,255,30,255,29,91,31,91,30,168,31,211,31,211,30,211,29,168,31,102,31,192,31,243,31,154,31,23,31,36,31,252,31,252,30,7,31,179,31,255,31,62,31,249,31,37,31,117,31,196,31,97,31,176,31,12,31,12,30,227,31,227,30,174,31,155,31,78,31,12,31,234,31,234,31,75,31,69,31,135,31,22,31,51,31,207,31,164,31,78,31,78,30,249,31,249,30,211,31,211,30,211,29,211,28,214,31,52,31,195,31,27,31,88,31,88,30,54,31,54,30,98,31,137,31,211,31,80,31,49,31,49,30,49,29,49,28,120,31,120,30,153,31,66,31,250,31,50,31,50,30,159,31,159,30,247,31,188,31,188,30,188,29,173,31,59,31,33,31,146,31,250,31,70,31,190,31,33,31,145,31,131,31,82,31,133,31,128,31,157,31,185,31,39,31,188,31,98,31,195,31,35,31,227,31,214,31,255,31,227,31,204,31,77,31,216,31,246,31,92,31,92,30,92,31,130,31,88,31);

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
