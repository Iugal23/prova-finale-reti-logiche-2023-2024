-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_113 is
end project_tb_113;

architecture project_tb_arch_113 of project_tb_113 is
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

constant SCENARIO_LENGTH : integer := 330;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (64,0,161,0,150,0,0,0,127,0,0,0,76,0,0,0,29,0,102,0,0,0,0,0,102,0,208,0,117,0,38,0,83,0,76,0,62,0,94,0,126,0,108,0,247,0,140,0,229,0,99,0,0,0,0,0,163,0,195,0,150,0,133,0,0,0,144,0,250,0,65,0,215,0,96,0,117,0,72,0,222,0,0,0,0,0,0,0,41,0,217,0,161,0,172,0,26,0,59,0,63,0,231,0,87,0,157,0,48,0,106,0,171,0,0,0,212,0,243,0,108,0,197,0,52,0,114,0,187,0,160,0,0,0,117,0,19,0,226,0,95,0,153,0,0,0,0,0,128,0,175,0,179,0,155,0,119,0,245,0,198,0,212,0,254,0,0,0,237,0,16,0,177,0,0,0,137,0,88,0,210,0,0,0,0,0,201,0,100,0,242,0,199,0,76,0,132,0,239,0,119,0,191,0,1,0,0,0,251,0,241,0,135,0,26,0,0,0,0,0,176,0,252,0,114,0,231,0,55,0,0,0,0,0,227,0,19,0,120,0,0,0,177,0,242,0,44,0,90,0,160,0,52,0,75,0,98,0,201,0,251,0,0,0,105,0,100,0,113,0,0,0,190,0,159,0,149,0,0,0,11,0,167,0,191,0,168,0,169,0,235,0,0,0,151,0,75,0,190,0,149,0,140,0,43,0,31,0,223,0,247,0,105,0,0,0,105,0,71,0,112,0,83,0,0,0,0,0,0,0,130,0,16,0,72,0,28,0,113,0,0,0,91,0,10,0,253,0,57,0,0,0,0,0,249,0,196,0,198,0,212,0,85,0,37,0,160,0,145,0,238,0,224,0,186,0,51,0,187,0,103,0,137,0,231,0,151,0,212,0,241,0,0,0,27,0,0,0,24,0,0,0,239,0,20,0,5,0,117,0,252,0,8,0,117,0,83,0,31,0,79,0,174,0,92,0,88,0,62,0,179,0,167,0,66,0,29,0,42,0,157,0,242,0,152,0,0,0,18,0,167,0,128,0,234,0,1,0,58,0,0,0,0,0,0,0,165,0,138,0,31,0,18,0,152,0,154,0,98,0,106,0,169,0,225,0,72,0,123,0,102,0,0,0,186,0,251,0,167,0,0,0,10,0,1,0,138,0,112,0,29,0,0,0,76,0,49,0,29,0,15,0,197,0,20,0,67,0,77,0,187,0,116,0,225,0,199,0,0,0,208,0,192,0,107,0,229,0,165,0,143,0,0,0,215,0,157,0,137,0,93,0,122,0,0,0,55,0,215,0,0,0,120,0,229,0,73,0,139,0,75,0,197,0,199,0,0,0,99,0,110,0,207,0,176,0,37,0,169,0,0,0,237,0,0,0,59,0,148,0,84,0,154,0,28,0,0,0,202,0,18,0,152,0,209,0,76,0,0,0,45,0,169,0,32,0,136,0,123,0,177,0,226,0,189,0,27,0,173,0,65,0,141,0,0,0,82,0,113,0);
signal scenario_full  : scenario_type := (64,31,161,31,150,31,150,30,127,31,127,30,76,31,76,30,29,31,102,31,102,30,102,29,102,31,208,31,117,31,38,31,83,31,76,31,62,31,94,31,126,31,108,31,247,31,140,31,229,31,99,31,99,30,99,29,163,31,195,31,150,31,133,31,133,30,144,31,250,31,65,31,215,31,96,31,117,31,72,31,222,31,222,30,222,29,222,28,41,31,217,31,161,31,172,31,26,31,59,31,63,31,231,31,87,31,157,31,48,31,106,31,171,31,171,30,212,31,243,31,108,31,197,31,52,31,114,31,187,31,160,31,160,30,117,31,19,31,226,31,95,31,153,31,153,30,153,29,128,31,175,31,179,31,155,31,119,31,245,31,198,31,212,31,254,31,254,30,237,31,16,31,177,31,177,30,137,31,88,31,210,31,210,30,210,29,201,31,100,31,242,31,199,31,76,31,132,31,239,31,119,31,191,31,1,31,1,30,251,31,241,31,135,31,26,31,26,30,26,29,176,31,252,31,114,31,231,31,55,31,55,30,55,29,227,31,19,31,120,31,120,30,177,31,242,31,44,31,90,31,160,31,52,31,75,31,98,31,201,31,251,31,251,30,105,31,100,31,113,31,113,30,190,31,159,31,149,31,149,30,11,31,167,31,191,31,168,31,169,31,235,31,235,30,151,31,75,31,190,31,149,31,140,31,43,31,31,31,223,31,247,31,105,31,105,30,105,31,71,31,112,31,83,31,83,30,83,29,83,28,130,31,16,31,72,31,28,31,113,31,113,30,91,31,10,31,253,31,57,31,57,30,57,29,249,31,196,31,198,31,212,31,85,31,37,31,160,31,145,31,238,31,224,31,186,31,51,31,187,31,103,31,137,31,231,31,151,31,212,31,241,31,241,30,27,31,27,30,24,31,24,30,239,31,20,31,5,31,117,31,252,31,8,31,117,31,83,31,31,31,79,31,174,31,92,31,88,31,62,31,179,31,167,31,66,31,29,31,42,31,157,31,242,31,152,31,152,30,18,31,167,31,128,31,234,31,1,31,58,31,58,30,58,29,58,28,165,31,138,31,31,31,18,31,152,31,154,31,98,31,106,31,169,31,225,31,72,31,123,31,102,31,102,30,186,31,251,31,167,31,167,30,10,31,1,31,138,31,112,31,29,31,29,30,76,31,49,31,29,31,15,31,197,31,20,31,67,31,77,31,187,31,116,31,225,31,199,31,199,30,208,31,192,31,107,31,229,31,165,31,143,31,143,30,215,31,157,31,137,31,93,31,122,31,122,30,55,31,215,31,215,30,120,31,229,31,73,31,139,31,75,31,197,31,199,31,199,30,99,31,110,31,207,31,176,31,37,31,169,31,169,30,237,31,237,30,59,31,148,31,84,31,154,31,28,31,28,30,202,31,18,31,152,31,209,31,76,31,76,30,45,31,169,31,32,31,136,31,123,31,177,31,226,31,189,31,27,31,173,31,65,31,141,31,141,30,82,31,113,31);

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
