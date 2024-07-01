-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_293 is
end project_tb_293;

architecture project_tb_arch_293 of project_tb_293 is
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

constant SCENARIO_LENGTH : integer := 278;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,94,0,15,0,232,0,0,0,142,0,98,0,131,0,194,0,161,0,59,0,148,0,142,0,13,0,89,0,157,0,228,0,192,0,0,0,105,0,83,0,26,0,0,0,198,0,15,0,22,0,27,0,217,0,254,0,0,0,69,0,121,0,21,0,0,0,19,0,0,0,95,0,88,0,134,0,0,0,230,0,117,0,218,0,5,0,182,0,126,0,0,0,38,0,0,0,112,0,0,0,229,0,66,0,250,0,0,0,60,0,187,0,0,0,211,0,126,0,0,0,140,0,3,0,33,0,183,0,48,0,233,0,193,0,242,0,0,0,15,0,0,0,249,0,14,0,0,0,17,0,218,0,68,0,128,0,184,0,83,0,149,0,49,0,38,0,1,0,220,0,82,0,0,0,79,0,0,0,0,0,116,0,155,0,0,0,0,0,29,0,173,0,143,0,46,0,60,0,0,0,98,0,0,0,0,0,102,0,70,0,73,0,136,0,56,0,0,0,13,0,179,0,83,0,65,0,37,0,45,0,25,0,113,0,209,0,250,0,12,0,0,0,182,0,136,0,249,0,175,0,120,0,0,0,205,0,74,0,116,0,72,0,249,0,108,0,187,0,0,0,178,0,163,0,177,0,232,0,57,0,222,0,0,0,0,0,180,0,64,0,133,0,0,0,204,0,130,0,193,0,137,0,197,0,51,0,0,0,193,0,45,0,177,0,219,0,141,0,210,0,29,0,192,0,99,0,0,0,0,0,199,0,25,0,0,0,194,0,0,0,199,0,14,0,149,0,22,0,34,0,0,0,169,0,213,0,72,0,0,0,120,0,125,0,0,0,0,0,98,0,129,0,199,0,235,0,157,0,216,0,0,0,217,0,9,0,0,0,97,0,0,0,200,0,32,0,166,0,138,0,145,0,150,0,204,0,167,0,0,0,0,0,77,0,204,0,103,0,127,0,232,0,77,0,149,0,113,0,0,0,157,0,138,0,139,0,31,0,203,0,215,0,111,0,166,0,0,0,237,0,215,0,164,0,46,0,0,0,216,0,128,0,116,0,244,0,244,0,113,0,149,0,92,0,57,0,44,0,0,0,0,0,0,0,87,0,0,0,248,0,121,0,0,0,90,0,209,0,0,0,44,0,6,0,161,0,223,0,198,0,33,0,252,0,212,0,192,0,242,0,92,0,64,0,11,0,126,0,68,0,209,0,94,0,0,0,0,0,177,0,92,0,228,0,80,0,188,0,0,0,236,0);
signal scenario_full  : scenario_type := (0,0,0,0,94,31,15,31,232,31,232,30,142,31,98,31,131,31,194,31,161,31,59,31,148,31,142,31,13,31,89,31,157,31,228,31,192,31,192,30,105,31,83,31,26,31,26,30,198,31,15,31,22,31,27,31,217,31,254,31,254,30,69,31,121,31,21,31,21,30,19,31,19,30,95,31,88,31,134,31,134,30,230,31,117,31,218,31,5,31,182,31,126,31,126,30,38,31,38,30,112,31,112,30,229,31,66,31,250,31,250,30,60,31,187,31,187,30,211,31,126,31,126,30,140,31,3,31,33,31,183,31,48,31,233,31,193,31,242,31,242,30,15,31,15,30,249,31,14,31,14,30,17,31,218,31,68,31,128,31,184,31,83,31,149,31,49,31,38,31,1,31,220,31,82,31,82,30,79,31,79,30,79,29,116,31,155,31,155,30,155,29,29,31,173,31,143,31,46,31,60,31,60,30,98,31,98,30,98,29,102,31,70,31,73,31,136,31,56,31,56,30,13,31,179,31,83,31,65,31,37,31,45,31,25,31,113,31,209,31,250,31,12,31,12,30,182,31,136,31,249,31,175,31,120,31,120,30,205,31,74,31,116,31,72,31,249,31,108,31,187,31,187,30,178,31,163,31,177,31,232,31,57,31,222,31,222,30,222,29,180,31,64,31,133,31,133,30,204,31,130,31,193,31,137,31,197,31,51,31,51,30,193,31,45,31,177,31,219,31,141,31,210,31,29,31,192,31,99,31,99,30,99,29,199,31,25,31,25,30,194,31,194,30,199,31,14,31,149,31,22,31,34,31,34,30,169,31,213,31,72,31,72,30,120,31,125,31,125,30,125,29,98,31,129,31,199,31,235,31,157,31,216,31,216,30,217,31,9,31,9,30,97,31,97,30,200,31,32,31,166,31,138,31,145,31,150,31,204,31,167,31,167,30,167,29,77,31,204,31,103,31,127,31,232,31,77,31,149,31,113,31,113,30,157,31,138,31,139,31,31,31,203,31,215,31,111,31,166,31,166,30,237,31,215,31,164,31,46,31,46,30,216,31,128,31,116,31,244,31,244,31,113,31,149,31,92,31,57,31,44,31,44,30,44,29,44,28,87,31,87,30,248,31,121,31,121,30,90,31,209,31,209,30,44,31,6,31,161,31,223,31,198,31,33,31,252,31,212,31,192,31,242,31,92,31,64,31,11,31,126,31,68,31,209,31,94,31,94,30,94,29,177,31,92,31,228,31,80,31,188,31,188,30,236,31);

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
