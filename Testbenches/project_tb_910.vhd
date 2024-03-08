-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_910 is
end project_tb_910;

architecture project_tb_arch_910 of project_tb_910 is
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

constant SCENARIO_LENGTH : integer := 342;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,72,0,96,0,140,0,198,0,53,0,47,0,240,0,18,0,26,0,15,0,186,0,0,0,212,0,0,0,152,0,31,0,169,0,0,0,0,0,187,0,240,0,0,0,73,0,212,0,154,0,2,0,89,0,251,0,46,0,11,0,133,0,248,0,47,0,14,0,68,0,0,0,84,0,33,0,223,0,0,0,220,0,0,0,248,0,0,0,202,0,0,0,6,0,236,0,63,0,114,0,92,0,224,0,219,0,181,0,32,0,225,0,80,0,122,0,0,0,127,0,0,0,165,0,0,0,112,0,0,0,220,0,23,0,225,0,21,0,156,0,6,0,168,0,141,0,179,0,0,0,222,0,0,0,0,0,171,0,0,0,0,0,215,0,0,0,216,0,64,0,189,0,56,0,148,0,0,0,135,0,239,0,0,0,157,0,0,0,52,0,6,0,0,0,0,0,239,0,227,0,140,0,184,0,200,0,207,0,130,0,43,0,3,0,45,0,0,0,246,0,0,0,0,0,129,0,0,0,231,0,74,0,117,0,0,0,124,0,0,0,0,0,0,0,211,0,40,0,91,0,130,0,112,0,0,0,160,0,196,0,53,0,176,0,255,0,170,0,168,0,246,0,132,0,250,0,233,0,0,0,0,0,0,0,48,0,142,0,63,0,222,0,84,0,115,0,0,0,250,0,166,0,247,0,203,0,0,0,253,0,73,0,164,0,53,0,154,0,0,0,49,0,151,0,72,0,141,0,196,0,183,0,45,0,238,0,91,0,148,0,0,0,170,0,30,0,0,0,137,0,147,0,145,0,0,0,196,0,128,0,5,0,242,0,3,0,198,0,0,0,222,0,38,0,199,0,210,0,93,0,171,0,201,0,157,0,194,0,0,0,64,0,43,0,18,0,12,0,84,0,244,0,154,0,171,0,223,0,0,0,98,0,133,0,229,0,158,0,249,0,0,0,160,0,0,0,150,0,0,0,0,0,170,0,0,0,0,0,0,0,0,0,220,0,158,0,241,0,95,0,78,0,210,0,39,0,0,0,197,0,0,0,24,0,180,0,0,0,33,0,12,0,197,0,175,0,206,0,0,0,183,0,103,0,0,0,237,0,160,0,96,0,163,0,173,0,143,0,0,0,46,0,0,0,218,0,0,0,249,0,20,0,249,0,211,0,222,0,84,0,171,0,0,0,161,0,89,0,117,0,124,0,0,0,161,0,142,0,10,0,105,0,188,0,3,0,4,0,121,0,134,0,99,0,39,0,0,0,129,0,221,0,14,0,215,0,89,0,54,0,38,0,169,0,136,0,219,0,226,0,167,0,0,0,150,0,196,0,191,0,56,0,167,0,82,0,255,0,157,0,0,0,201,0,176,0,179,0,235,0,169,0,0,0,0,0,191,0,0,0,0,0,34,0,115,0,135,0,77,0,255,0,0,0,0,0,165,0,136,0,35,0,0,0,99,0,135,0,202,0,0,0,0,0,193,0,199,0,110,0,232,0,224,0,240,0,246,0,19,0,111,0,245,0,186,0,10,0,179,0,0,0);
signal scenario_full  : scenario_type := (0,0,72,31,96,31,140,31,198,31,53,31,47,31,240,31,18,31,26,31,15,31,186,31,186,30,212,31,212,30,152,31,31,31,169,31,169,30,169,29,187,31,240,31,240,30,73,31,212,31,154,31,2,31,89,31,251,31,46,31,11,31,133,31,248,31,47,31,14,31,68,31,68,30,84,31,33,31,223,31,223,30,220,31,220,30,248,31,248,30,202,31,202,30,6,31,236,31,63,31,114,31,92,31,224,31,219,31,181,31,32,31,225,31,80,31,122,31,122,30,127,31,127,30,165,31,165,30,112,31,112,30,220,31,23,31,225,31,21,31,156,31,6,31,168,31,141,31,179,31,179,30,222,31,222,30,222,29,171,31,171,30,171,29,215,31,215,30,216,31,64,31,189,31,56,31,148,31,148,30,135,31,239,31,239,30,157,31,157,30,52,31,6,31,6,30,6,29,239,31,227,31,140,31,184,31,200,31,207,31,130,31,43,31,3,31,45,31,45,30,246,31,246,30,246,29,129,31,129,30,231,31,74,31,117,31,117,30,124,31,124,30,124,29,124,28,211,31,40,31,91,31,130,31,112,31,112,30,160,31,196,31,53,31,176,31,255,31,170,31,168,31,246,31,132,31,250,31,233,31,233,30,233,29,233,28,48,31,142,31,63,31,222,31,84,31,115,31,115,30,250,31,166,31,247,31,203,31,203,30,253,31,73,31,164,31,53,31,154,31,154,30,49,31,151,31,72,31,141,31,196,31,183,31,45,31,238,31,91,31,148,31,148,30,170,31,30,31,30,30,137,31,147,31,145,31,145,30,196,31,128,31,5,31,242,31,3,31,198,31,198,30,222,31,38,31,199,31,210,31,93,31,171,31,201,31,157,31,194,31,194,30,64,31,43,31,18,31,12,31,84,31,244,31,154,31,171,31,223,31,223,30,98,31,133,31,229,31,158,31,249,31,249,30,160,31,160,30,150,31,150,30,150,29,170,31,170,30,170,29,170,28,170,27,220,31,158,31,241,31,95,31,78,31,210,31,39,31,39,30,197,31,197,30,24,31,180,31,180,30,33,31,12,31,197,31,175,31,206,31,206,30,183,31,103,31,103,30,237,31,160,31,96,31,163,31,173,31,143,31,143,30,46,31,46,30,218,31,218,30,249,31,20,31,249,31,211,31,222,31,84,31,171,31,171,30,161,31,89,31,117,31,124,31,124,30,161,31,142,31,10,31,105,31,188,31,3,31,4,31,121,31,134,31,99,31,39,31,39,30,129,31,221,31,14,31,215,31,89,31,54,31,38,31,169,31,136,31,219,31,226,31,167,31,167,30,150,31,196,31,191,31,56,31,167,31,82,31,255,31,157,31,157,30,201,31,176,31,179,31,235,31,169,31,169,30,169,29,191,31,191,30,191,29,34,31,115,31,135,31,77,31,255,31,255,30,255,29,165,31,136,31,35,31,35,30,99,31,135,31,202,31,202,30,202,29,193,31,199,31,110,31,232,31,224,31,240,31,246,31,19,31,111,31,245,31,186,31,10,31,179,31,179,30);

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
