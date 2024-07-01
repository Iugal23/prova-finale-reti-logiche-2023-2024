-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_361 is
end project_tb_361;

architecture project_tb_arch_361 of project_tb_361 is
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

constant SCENARIO_LENGTH : integer := 194;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (90,0,147,0,166,0,171,0,142,0,0,0,253,0,113,0,0,0,241,0,0,0,68,0,0,0,22,0,205,0,190,0,17,0,99,0,159,0,70,0,231,0,0,0,21,0,0,0,101,0,135,0,142,0,255,0,157,0,48,0,74,0,0,0,199,0,0,0,61,0,91,0,102,0,12,0,128,0,135,0,111,0,0,0,226,0,46,0,140,0,186,0,211,0,79,0,5,0,171,0,0,0,67,0,0,0,0,0,219,0,80,0,19,0,214,0,69,0,17,0,31,0,0,0,195,0,61,0,197,0,217,0,205,0,198,0,12,0,0,0,201,0,133,0,0,0,0,0,0,0,183,0,0,0,195,0,0,0,170,0,21,0,188,0,141,0,171,0,62,0,204,0,0,0,85,0,44,0,140,0,253,0,100,0,0,0,54,0,240,0,58,0,58,0,253,0,130,0,41,0,36,0,96,0,149,0,1,0,153,0,188,0,224,0,0,0,85,0,137,0,224,0,90,0,72,0,0,0,0,0,21,0,244,0,198,0,0,0,43,0,179,0,75,0,0,0,114,0,27,0,0,0,192,0,0,0,28,0,135,0,161,0,33,0,112,0,204,0,130,0,35,0,0,0,150,0,230,0,153,0,0,0,189,0,96,0,0,0,200,0,94,0,74,0,0,0,113,0,27,0,0,0,61,0,83,0,44,0,0,0,78,0,0,0,21,0,0,0,250,0,13,0,0,0,91,0,64,0,202,0,0,0,0,0,0,0,220,0,209,0,99,0,174,0,11,0,39,0,0,0,57,0,28,0,0,0,0,0,243,0,95,0,75,0,190,0,136,0,114,0,8,0,191,0,86,0,101,0,0,0,43,0,15,0,25,0,157,0);
signal scenario_full  : scenario_type := (90,31,147,31,166,31,171,31,142,31,142,30,253,31,113,31,113,30,241,31,241,30,68,31,68,30,22,31,205,31,190,31,17,31,99,31,159,31,70,31,231,31,231,30,21,31,21,30,101,31,135,31,142,31,255,31,157,31,48,31,74,31,74,30,199,31,199,30,61,31,91,31,102,31,12,31,128,31,135,31,111,31,111,30,226,31,46,31,140,31,186,31,211,31,79,31,5,31,171,31,171,30,67,31,67,30,67,29,219,31,80,31,19,31,214,31,69,31,17,31,31,31,31,30,195,31,61,31,197,31,217,31,205,31,198,31,12,31,12,30,201,31,133,31,133,30,133,29,133,28,183,31,183,30,195,31,195,30,170,31,21,31,188,31,141,31,171,31,62,31,204,31,204,30,85,31,44,31,140,31,253,31,100,31,100,30,54,31,240,31,58,31,58,31,253,31,130,31,41,31,36,31,96,31,149,31,1,31,153,31,188,31,224,31,224,30,85,31,137,31,224,31,90,31,72,31,72,30,72,29,21,31,244,31,198,31,198,30,43,31,179,31,75,31,75,30,114,31,27,31,27,30,192,31,192,30,28,31,135,31,161,31,33,31,112,31,204,31,130,31,35,31,35,30,150,31,230,31,153,31,153,30,189,31,96,31,96,30,200,31,94,31,74,31,74,30,113,31,27,31,27,30,61,31,83,31,44,31,44,30,78,31,78,30,21,31,21,30,250,31,13,31,13,30,91,31,64,31,202,31,202,30,202,29,202,28,220,31,209,31,99,31,174,31,11,31,39,31,39,30,57,31,28,31,28,30,28,29,243,31,95,31,75,31,190,31,136,31,114,31,8,31,191,31,86,31,101,31,101,30,43,31,15,31,25,31,157,31);

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
