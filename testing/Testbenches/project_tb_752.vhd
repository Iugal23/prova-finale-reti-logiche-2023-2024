-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_752 is
end project_tb_752;

architecture project_tb_arch_752 of project_tb_752 is
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

constant SCENARIO_LENGTH : integer := 201;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (243,0,243,0,86,0,0,0,72,0,0,0,28,0,40,0,69,0,176,0,66,0,181,0,0,0,32,0,1,0,31,0,111,0,0,0,69,0,0,0,216,0,0,0,164,0,211,0,174,0,0,0,204,0,205,0,178,0,177,0,0,0,199,0,92,0,0,0,59,0,188,0,0,0,223,0,67,0,229,0,41,0,172,0,0,0,145,0,0,0,77,0,74,0,9,0,141,0,81,0,30,0,0,0,165,0,30,0,0,0,148,0,95,0,78,0,0,0,46,0,135,0,70,0,0,0,139,0,173,0,215,0,215,0,40,0,174,0,140,0,248,0,53,0,187,0,198,0,0,0,68,0,0,0,108,0,157,0,8,0,166,0,208,0,159,0,242,0,6,0,218,0,206,0,157,0,70,0,237,0,114,0,0,0,0,0,176,0,179,0,219,0,0,0,214,0,247,0,146,0,220,0,47,0,0,0,156,0,97,0,49,0,192,0,0,0,101,0,78,0,109,0,108,0,188,0,91,0,149,0,192,0,209,0,125,0,179,0,0,0,207,0,0,0,94,0,118,0,16,0,166,0,0,0,0,0,184,0,69,0,102,0,249,0,0,0,38,0,97,0,0,0,154,0,31,0,208,0,255,0,194,0,137,0,72,0,41,0,29,0,1,0,144,0,0,0,176,0,142,0,217,0,204,0,223,0,161,0,104,0,45,0,221,0,148,0,226,0,0,0,76,0,0,0,166,0,159,0,74,0,58,0,175,0,210,0,0,0,0,0,27,0,69,0,187,0,48,0,254,0,254,0,123,0,0,0,21,0,215,0,89,0,0,0,112,0,131,0,230,0,236,0,219,0,0,0,174,0,100,0,105,0,32,0,0,0,0,0,9,0,197,0,0,0,0,0,49,0,191,0,220,0);
signal scenario_full  : scenario_type := (243,31,243,31,86,31,86,30,72,31,72,30,28,31,40,31,69,31,176,31,66,31,181,31,181,30,32,31,1,31,31,31,111,31,111,30,69,31,69,30,216,31,216,30,164,31,211,31,174,31,174,30,204,31,205,31,178,31,177,31,177,30,199,31,92,31,92,30,59,31,188,31,188,30,223,31,67,31,229,31,41,31,172,31,172,30,145,31,145,30,77,31,74,31,9,31,141,31,81,31,30,31,30,30,165,31,30,31,30,30,148,31,95,31,78,31,78,30,46,31,135,31,70,31,70,30,139,31,173,31,215,31,215,31,40,31,174,31,140,31,248,31,53,31,187,31,198,31,198,30,68,31,68,30,108,31,157,31,8,31,166,31,208,31,159,31,242,31,6,31,218,31,206,31,157,31,70,31,237,31,114,31,114,30,114,29,176,31,179,31,219,31,219,30,214,31,247,31,146,31,220,31,47,31,47,30,156,31,97,31,49,31,192,31,192,30,101,31,78,31,109,31,108,31,188,31,91,31,149,31,192,31,209,31,125,31,179,31,179,30,207,31,207,30,94,31,118,31,16,31,166,31,166,30,166,29,184,31,69,31,102,31,249,31,249,30,38,31,97,31,97,30,154,31,31,31,208,31,255,31,194,31,137,31,72,31,41,31,29,31,1,31,144,31,144,30,176,31,142,31,217,31,204,31,223,31,161,31,104,31,45,31,221,31,148,31,226,31,226,30,76,31,76,30,166,31,159,31,74,31,58,31,175,31,210,31,210,30,210,29,27,31,69,31,187,31,48,31,254,31,254,31,123,31,123,30,21,31,215,31,89,31,89,30,112,31,131,31,230,31,236,31,219,31,219,30,174,31,100,31,105,31,32,31,32,30,32,29,9,31,197,31,197,30,197,29,49,31,191,31,220,31);

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
