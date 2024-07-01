-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_351 is
end project_tb_351;

architecture project_tb_arch_351 of project_tb_351 is
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

constant SCENARIO_LENGTH : integer := 304;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,149,0,0,0,0,0,252,0,38,0,71,0,109,0,144,0,238,0,192,0,241,0,64,0,23,0,13,0,145,0,167,0,85,0,0,0,93,0,235,0,126,0,15,0,135,0,105,0,0,0,99,0,27,0,156,0,153,0,151,0,231,0,79,0,76,0,27,0,18,0,0,0,77,0,32,0,43,0,237,0,178,0,0,0,0,0,51,0,221,0,162,0,217,0,216,0,32,0,95,0,233,0,250,0,118,0,12,0,0,0,192,0,124,0,154,0,202,0,71,0,0,0,209,0,214,0,155,0,192,0,219,0,12,0,32,0,82,0,100,0,1,0,230,0,124,0,149,0,9,0,0,0,7,0,221,0,115,0,1,0,170,0,158,0,202,0,0,0,0,0,227,0,76,0,32,0,18,0,0,0,12,0,43,0,0,0,114,0,0,0,92,0,219,0,0,0,239,0,58,0,103,0,168,0,211,0,65,0,0,0,211,0,247,0,207,0,121,0,231,0,0,0,227,0,0,0,149,0,235,0,38,0,103,0,96,0,164,0,0,0,0,0,164,0,0,0,55,0,182,0,58,0,0,0,108,0,106,0,64,0,71,0,124,0,91,0,182,0,134,0,85,0,0,0,31,0,74,0,0,0,0,0,131,0,0,0,173,0,194,0,233,0,0,0,218,0,178,0,56,0,0,0,44,0,200,0,189,0,0,0,132,0,198,0,122,0,84,0,17,0,83,0,134,0,230,0,0,0,0,0,0,0,145,0,165,0,214,0,37,0,50,0,122,0,0,0,151,0,0,0,66,0,10,0,0,0,201,0,72,0,179,0,57,0,92,0,92,0,132,0,0,0,0,0,0,0,60,0,183,0,0,0,90,0,232,0,0,0,0,0,0,0,166,0,131,0,86,0,184,0,0,0,192,0,0,0,72,0,197,0,251,0,139,0,156,0,77,0,155,0,0,0,81,0,251,0,210,0,0,0,105,0,15,0,42,0,0,0,47,0,113,0,163,0,194,0,0,0,67,0,126,0,139,0,199,0,0,0,169,0,107,0,213,0,0,0,114,0,63,0,0,0,197,0,89,0,57,0,66,0,139,0,55,0,243,0,216,0,84,0,192,0,208,0,40,0,241,0,216,0,50,0,217,0,115,0,195,0,2,0,0,0,0,0,0,0,87,0,170,0,0,0,0,0,124,0,159,0,80,0,220,0,24,0,64,0,69,0,175,0,160,0,0,0,186,0,0,0,42,0,0,0,96,0,155,0,75,0,249,0,0,0,0,0,0,0,79,0,219,0,183,0,0,0,253,0,1,0,114,0,90,0,0,0,0,0,100,0,99,0,199,0,197,0,173,0,0,0,45,0,17,0,172,0,167,0);
signal scenario_full  : scenario_type := (0,0,149,31,149,30,149,29,252,31,38,31,71,31,109,31,144,31,238,31,192,31,241,31,64,31,23,31,13,31,145,31,167,31,85,31,85,30,93,31,235,31,126,31,15,31,135,31,105,31,105,30,99,31,27,31,156,31,153,31,151,31,231,31,79,31,76,31,27,31,18,31,18,30,77,31,32,31,43,31,237,31,178,31,178,30,178,29,51,31,221,31,162,31,217,31,216,31,32,31,95,31,233,31,250,31,118,31,12,31,12,30,192,31,124,31,154,31,202,31,71,31,71,30,209,31,214,31,155,31,192,31,219,31,12,31,32,31,82,31,100,31,1,31,230,31,124,31,149,31,9,31,9,30,7,31,221,31,115,31,1,31,170,31,158,31,202,31,202,30,202,29,227,31,76,31,32,31,18,31,18,30,12,31,43,31,43,30,114,31,114,30,92,31,219,31,219,30,239,31,58,31,103,31,168,31,211,31,65,31,65,30,211,31,247,31,207,31,121,31,231,31,231,30,227,31,227,30,149,31,235,31,38,31,103,31,96,31,164,31,164,30,164,29,164,31,164,30,55,31,182,31,58,31,58,30,108,31,106,31,64,31,71,31,124,31,91,31,182,31,134,31,85,31,85,30,31,31,74,31,74,30,74,29,131,31,131,30,173,31,194,31,233,31,233,30,218,31,178,31,56,31,56,30,44,31,200,31,189,31,189,30,132,31,198,31,122,31,84,31,17,31,83,31,134,31,230,31,230,30,230,29,230,28,145,31,165,31,214,31,37,31,50,31,122,31,122,30,151,31,151,30,66,31,10,31,10,30,201,31,72,31,179,31,57,31,92,31,92,31,132,31,132,30,132,29,132,28,60,31,183,31,183,30,90,31,232,31,232,30,232,29,232,28,166,31,131,31,86,31,184,31,184,30,192,31,192,30,72,31,197,31,251,31,139,31,156,31,77,31,155,31,155,30,81,31,251,31,210,31,210,30,105,31,15,31,42,31,42,30,47,31,113,31,163,31,194,31,194,30,67,31,126,31,139,31,199,31,199,30,169,31,107,31,213,31,213,30,114,31,63,31,63,30,197,31,89,31,57,31,66,31,139,31,55,31,243,31,216,31,84,31,192,31,208,31,40,31,241,31,216,31,50,31,217,31,115,31,195,31,2,31,2,30,2,29,2,28,87,31,170,31,170,30,170,29,124,31,159,31,80,31,220,31,24,31,64,31,69,31,175,31,160,31,160,30,186,31,186,30,42,31,42,30,96,31,155,31,75,31,249,31,249,30,249,29,249,28,79,31,219,31,183,31,183,30,253,31,1,31,114,31,90,31,90,30,90,29,100,31,99,31,199,31,197,31,173,31,173,30,45,31,17,31,172,31,167,31);

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
