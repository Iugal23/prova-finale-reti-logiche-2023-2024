-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_92 is
end project_tb_92;

architecture project_tb_arch_92 of project_tb_92 is
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

constant SCENARIO_LENGTH : integer := 164;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (135,0,237,0,69,0,42,0,20,0,10,0,190,0,47,0,161,0,179,0,232,0,43,0,197,0,115,0,33,0,1,0,36,0,173,0,0,0,130,0,90,0,9,0,160,0,52,0,241,0,193,0,240,0,14,0,70,0,113,0,103,0,161,0,44,0,7,0,0,0,169,0,238,0,0,0,0,0,9,0,200,0,191,0,0,0,119,0,131,0,134,0,165,0,90,0,148,0,148,0,98,0,82,0,193,0,5,0,63,0,16,0,122,0,182,0,66,0,58,0,0,0,47,0,49,0,129,0,215,0,26,0,102,0,33,0,130,0,49,0,0,0,172,0,44,0,136,0,0,0,233,0,54,0,94,0,135,0,110,0,99,0,0,0,167,0,0,0,52,0,162,0,0,0,0,0,155,0,26,0,208,0,0,0,0,0,2,0,184,0,114,0,117,0,189,0,0,0,24,0,24,0,172,0,156,0,64,0,60,0,29,0,67,0,138,0,215,0,214,0,0,0,115,0,0,0,181,0,240,0,54,0,246,0,129,0,250,0,158,0,34,0,241,0,0,0,253,0,151,0,0,0,177,0,0,0,51,0,27,0,97,0,81,0,0,0,179,0,0,0,90,0,11,0,0,0,0,0,222,0,0,0,197,0,175,0,0,0,67,0,139,0,212,0,89,0,0,0,126,0,28,0,62,0,41,0,202,0,188,0,214,0,210,0,154,0,87,0,254,0,99,0,42,0,211,0,124,0);
signal scenario_full  : scenario_type := (135,31,237,31,69,31,42,31,20,31,10,31,190,31,47,31,161,31,179,31,232,31,43,31,197,31,115,31,33,31,1,31,36,31,173,31,173,30,130,31,90,31,9,31,160,31,52,31,241,31,193,31,240,31,14,31,70,31,113,31,103,31,161,31,44,31,7,31,7,30,169,31,238,31,238,30,238,29,9,31,200,31,191,31,191,30,119,31,131,31,134,31,165,31,90,31,148,31,148,31,98,31,82,31,193,31,5,31,63,31,16,31,122,31,182,31,66,31,58,31,58,30,47,31,49,31,129,31,215,31,26,31,102,31,33,31,130,31,49,31,49,30,172,31,44,31,136,31,136,30,233,31,54,31,94,31,135,31,110,31,99,31,99,30,167,31,167,30,52,31,162,31,162,30,162,29,155,31,26,31,208,31,208,30,208,29,2,31,184,31,114,31,117,31,189,31,189,30,24,31,24,31,172,31,156,31,64,31,60,31,29,31,67,31,138,31,215,31,214,31,214,30,115,31,115,30,181,31,240,31,54,31,246,31,129,31,250,31,158,31,34,31,241,31,241,30,253,31,151,31,151,30,177,31,177,30,51,31,27,31,97,31,81,31,81,30,179,31,179,30,90,31,11,31,11,30,11,29,222,31,222,30,197,31,175,31,175,30,67,31,139,31,212,31,89,31,89,30,126,31,28,31,62,31,41,31,202,31,188,31,214,31,210,31,154,31,87,31,254,31,99,31,42,31,211,31,124,31);

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
