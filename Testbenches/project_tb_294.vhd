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

constant SCENARIO_LENGTH : integer := 235;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (224,0,162,0,35,0,0,0,249,0,237,0,233,0,0,0,215,0,0,0,0,0,156,0,117,0,171,0,135,0,0,0,9,0,0,0,42,0,164,0,48,0,0,0,224,0,0,0,26,0,236,0,12,0,0,0,41,0,32,0,92,0,240,0,130,0,54,0,0,0,91,0,216,0,27,0,46,0,177,0,0,0,0,0,0,0,10,0,176,0,238,0,201,0,87,0,185,0,0,0,75,0,206,0,192,0,246,0,80,0,110,0,70,0,201,0,78,0,34,0,0,0,232,0,20,0,0,0,95,0,166,0,114,0,41,0,3,0,225,0,51,0,4,0,0,0,0,0,132,0,0,0,58,0,161,0,238,0,32,0,156,0,97,0,0,0,0,0,212,0,0,0,136,0,60,0,98,0,93,0,211,0,0,0,0,0,155,0,12,0,205,0,38,0,191,0,251,0,0,0,95,0,24,0,32,0,78,0,121,0,245,0,105,0,95,0,158,0,222,0,0,0,0,0,69,0,242,0,160,0,162,0,0,0,106,0,182,0,0,0,216,0,161,0,0,0,0,0,82,0,113,0,36,0,253,0,232,0,143,0,148,0,0,0,202,0,0,0,245,0,0,0,206,0,95,0,255,0,0,0,0,0,10,0,249,0,0,0,126,0,143,0,196,0,0,0,247,0,167,0,241,0,161,0,188,0,137,0,158,0,85,0,165,0,181,0,221,0,173,0,0,0,112,0,60,0,0,0,166,0,75,0,152,0,226,0,91,0,0,0,103,0,30,0,159,0,40,0,11,0,40,0,56,0,0,0,248,0,51,0,171,0,0,0,169,0,86,0,242,0,144,0,30,0,39,0,86,0,249,0,227,0,0,0,69,0,147,0,127,0,26,0,228,0,0,0,222,0,152,0,177,0,181,0,45,0,25,0,3,0,173,0,7,0,173,0,35,0,196,0,92,0,72,0,66,0,0,0,70,0,201,0,60,0,0,0,242,0,100,0,33,0,0,0,0,0,246,0,251,0,90,0,0,0,162,0,116,0,13,0,78,0,158,0,72,0,19,0,200,0);
signal scenario_full  : scenario_type := (224,31,162,31,35,31,35,30,249,31,237,31,233,31,233,30,215,31,215,30,215,29,156,31,117,31,171,31,135,31,135,30,9,31,9,30,42,31,164,31,48,31,48,30,224,31,224,30,26,31,236,31,12,31,12,30,41,31,32,31,92,31,240,31,130,31,54,31,54,30,91,31,216,31,27,31,46,31,177,31,177,30,177,29,177,28,10,31,176,31,238,31,201,31,87,31,185,31,185,30,75,31,206,31,192,31,246,31,80,31,110,31,70,31,201,31,78,31,34,31,34,30,232,31,20,31,20,30,95,31,166,31,114,31,41,31,3,31,225,31,51,31,4,31,4,30,4,29,132,31,132,30,58,31,161,31,238,31,32,31,156,31,97,31,97,30,97,29,212,31,212,30,136,31,60,31,98,31,93,31,211,31,211,30,211,29,155,31,12,31,205,31,38,31,191,31,251,31,251,30,95,31,24,31,32,31,78,31,121,31,245,31,105,31,95,31,158,31,222,31,222,30,222,29,69,31,242,31,160,31,162,31,162,30,106,31,182,31,182,30,216,31,161,31,161,30,161,29,82,31,113,31,36,31,253,31,232,31,143,31,148,31,148,30,202,31,202,30,245,31,245,30,206,31,95,31,255,31,255,30,255,29,10,31,249,31,249,30,126,31,143,31,196,31,196,30,247,31,167,31,241,31,161,31,188,31,137,31,158,31,85,31,165,31,181,31,221,31,173,31,173,30,112,31,60,31,60,30,166,31,75,31,152,31,226,31,91,31,91,30,103,31,30,31,159,31,40,31,11,31,40,31,56,31,56,30,248,31,51,31,171,31,171,30,169,31,86,31,242,31,144,31,30,31,39,31,86,31,249,31,227,31,227,30,69,31,147,31,127,31,26,31,228,31,228,30,222,31,152,31,177,31,181,31,45,31,25,31,3,31,173,31,7,31,173,31,35,31,196,31,92,31,72,31,66,31,66,30,70,31,201,31,60,31,60,30,242,31,100,31,33,31,33,30,33,29,246,31,251,31,90,31,90,30,162,31,116,31,13,31,78,31,158,31,72,31,19,31,200,31);

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
