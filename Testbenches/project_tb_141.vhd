-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_141 is
end project_tb_141;

architecture project_tb_arch_141 of project_tb_141 is
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

constant SCENARIO_LENGTH : integer := 295;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (137,0,60,0,120,0,224,0,93,0,0,0,237,0,7,0,103,0,150,0,200,0,16,0,152,0,171,0,18,0,148,0,245,0,205,0,115,0,105,0,114,0,0,0,206,0,196,0,176,0,238,0,108,0,0,0,124,0,70,0,18,0,73,0,241,0,101,0,214,0,7,0,0,0,89,0,126,0,254,0,0,0,213,0,108,0,0,0,212,0,157,0,92,0,0,0,71,0,191,0,137,0,246,0,7,0,18,0,11,0,46,0,215,0,177,0,57,0,80,0,0,0,49,0,141,0,84,0,128,0,196,0,0,0,132,0,251,0,205,0,104,0,90,0,61,0,59,0,0,0,102,0,189,0,34,0,142,0,0,0,0,0,104,0,0,0,219,0,57,0,0,0,43,0,57,0,11,0,63,0,147,0,54,0,183,0,243,0,0,0,126,0,0,0,0,0,156,0,235,0,0,0,76,0,170,0,147,0,4,0,192,0,225,0,0,0,59,0,111,0,136,0,43,0,0,0,0,0,101,0,211,0,225,0,0,0,0,0,45,0,101,0,10,0,0,0,13,0,141,0,80,0,199,0,122,0,101,0,73,0,179,0,0,0,0,0,137,0,234,0,249,0,17,0,126,0,227,0,248,0,181,0,45,0,155,0,55,0,161,0,0,0,103,0,228,0,29,0,187,0,166,0,78,0,26,0,69,0,64,0,0,0,73,0,38,0,106,0,113,0,13,0,80,0,0,0,135,0,39,0,114,0,198,0,239,0,246,0,0,0,0,0,160,0,206,0,148,0,55,0,0,0,188,0,118,0,65,0,194,0,126,0,39,0,89,0,0,0,13,0,85,0,131,0,110,0,94,0,10,0,3,0,37,0,7,0,117,0,101,0,203,0,50,0,49,0,0,0,113,0,19,0,28,0,205,0,235,0,211,0,143,0,116,0,127,0,164,0,3,0,35,0,238,0,0,0,195,0,191,0,178,0,17,0,0,0,35,0,224,0,25,0,94,0,119,0,0,0,0,0,65,0,88,0,42,0,0,0,105,0,73,0,73,0,182,0,95,0,53,0,144,0,0,0,157,0,224,0,155,0,23,0,124,0,247,0,16,0,218,0,26,0,156,0,58,0,0,0,218,0,37,0,40,0,0,0,0,0,255,0,87,0,0,0,199,0,63,0,11,0,88,0,12,0,188,0,59,0,237,0,0,0,233,0,247,0,0,0,129,0,87,0,70,0,93,0,0,0,0,0,34,0,120,0,215,0,0,0,189,0,14,0,0,0,154,0,196,0,225,0,14,0,0,0,69,0,100,0,248,0,69,0,0,0,226,0,2,0,32,0);
signal scenario_full  : scenario_type := (137,31,60,31,120,31,224,31,93,31,93,30,237,31,7,31,103,31,150,31,200,31,16,31,152,31,171,31,18,31,148,31,245,31,205,31,115,31,105,31,114,31,114,30,206,31,196,31,176,31,238,31,108,31,108,30,124,31,70,31,18,31,73,31,241,31,101,31,214,31,7,31,7,30,89,31,126,31,254,31,254,30,213,31,108,31,108,30,212,31,157,31,92,31,92,30,71,31,191,31,137,31,246,31,7,31,18,31,11,31,46,31,215,31,177,31,57,31,80,31,80,30,49,31,141,31,84,31,128,31,196,31,196,30,132,31,251,31,205,31,104,31,90,31,61,31,59,31,59,30,102,31,189,31,34,31,142,31,142,30,142,29,104,31,104,30,219,31,57,31,57,30,43,31,57,31,11,31,63,31,147,31,54,31,183,31,243,31,243,30,126,31,126,30,126,29,156,31,235,31,235,30,76,31,170,31,147,31,4,31,192,31,225,31,225,30,59,31,111,31,136,31,43,31,43,30,43,29,101,31,211,31,225,31,225,30,225,29,45,31,101,31,10,31,10,30,13,31,141,31,80,31,199,31,122,31,101,31,73,31,179,31,179,30,179,29,137,31,234,31,249,31,17,31,126,31,227,31,248,31,181,31,45,31,155,31,55,31,161,31,161,30,103,31,228,31,29,31,187,31,166,31,78,31,26,31,69,31,64,31,64,30,73,31,38,31,106,31,113,31,13,31,80,31,80,30,135,31,39,31,114,31,198,31,239,31,246,31,246,30,246,29,160,31,206,31,148,31,55,31,55,30,188,31,118,31,65,31,194,31,126,31,39,31,89,31,89,30,13,31,85,31,131,31,110,31,94,31,10,31,3,31,37,31,7,31,117,31,101,31,203,31,50,31,49,31,49,30,113,31,19,31,28,31,205,31,235,31,211,31,143,31,116,31,127,31,164,31,3,31,35,31,238,31,238,30,195,31,191,31,178,31,17,31,17,30,35,31,224,31,25,31,94,31,119,31,119,30,119,29,65,31,88,31,42,31,42,30,105,31,73,31,73,31,182,31,95,31,53,31,144,31,144,30,157,31,224,31,155,31,23,31,124,31,247,31,16,31,218,31,26,31,156,31,58,31,58,30,218,31,37,31,40,31,40,30,40,29,255,31,87,31,87,30,199,31,63,31,11,31,88,31,12,31,188,31,59,31,237,31,237,30,233,31,247,31,247,30,129,31,87,31,70,31,93,31,93,30,93,29,34,31,120,31,215,31,215,30,189,31,14,31,14,30,154,31,196,31,225,31,14,31,14,30,69,31,100,31,248,31,69,31,69,30,226,31,2,31,32,31);

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
