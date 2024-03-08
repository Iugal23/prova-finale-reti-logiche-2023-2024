-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_134 is
end project_tb_134;

architecture project_tb_arch_134 of project_tb_134 is
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

constant SCENARIO_LENGTH : integer := 296;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (200,0,19,0,206,0,17,0,62,0,59,0,101,0,0,0,183,0,211,0,115,0,133,0,0,0,140,0,216,0,193,0,0,0,50,0,0,0,115,0,248,0,177,0,96,0,231,0,190,0,181,0,181,0,0,0,230,0,212,0,35,0,2,0,127,0,37,0,0,0,81,0,4,0,140,0,163,0,63,0,0,0,36,0,12,0,81,0,0,0,159,0,207,0,0,0,164,0,0,0,228,0,32,0,0,0,41,0,228,0,0,0,0,0,0,0,187,0,56,0,131,0,0,0,211,0,205,0,125,0,173,0,187,0,244,0,109,0,194,0,0,0,160,0,75,0,217,0,27,0,13,0,254,0,110,0,0,0,11,0,240,0,117,0,159,0,83,0,207,0,135,0,94,0,23,0,217,0,220,0,184,0,8,0,96,0,113,0,87,0,194,0,59,0,0,0,173,0,71,0,46,0,88,0,206,0,197,0,94,0,114,0,114,0,0,0,215,0,141,0,171,0,218,0,47,0,122,0,0,0,0,0,203,0,0,0,2,0,0,0,180,0,84,0,52,0,173,0,231,0,107,0,138,0,64,0,77,0,0,0,171,0,74,0,0,0,220,0,69,0,0,0,0,0,167,0,65,0,0,0,31,0,2,0,0,0,0,0,0,0,159,0,40,0,0,0,89,0,137,0,183,0,164,0,13,0,0,0,184,0,217,0,179,0,183,0,51,0,95,0,76,0,198,0,55,0,164,0,155,0,0,0,0,0,81,0,6,0,239,0,247,0,197,0,0,0,0,0,0,0,0,0,75,0,0,0,33,0,103,0,158,0,0,0,118,0,127,0,66,0,111,0,177,0,233,0,158,0,56,0,0,0,67,0,0,0,152,0,0,0,43,0,0,0,21,0,101,0,196,0,208,0,0,0,0,0,193,0,95,0,49,0,0,0,241,0,91,0,18,0,200,0,86,0,0,0,167,0,140,0,108,0,67,0,246,0,5,0,0,0,229,0,0,0,0,0,2,0,225,0,173,0,47,0,197,0,228,0,41,0,87,0,83,0,8,0,41,0,158,0,165,0,0,0,254,0,138,0,0,0,135,0,38,0,0,0,149,0,251,0,187,0,68,0,0,0,189,0,99,0,154,0,56,0,31,0,91,0,140,0,109,0,0,0,72,0,27,0,0,0,79,0,37,0,131,0,0,0,85,0,0,0,108,0,52,0,0,0,0,0,247,0,102,0,103,0,70,0,0,0,154,0,147,0,143,0,37,0,0,0,15,0,91,0,203,0,13,0,253,0,0,0,87,0,170,0,0,0,13,0,108,0,49,0,34,0,0,0,101,0,230,0);
signal scenario_full  : scenario_type := (200,31,19,31,206,31,17,31,62,31,59,31,101,31,101,30,183,31,211,31,115,31,133,31,133,30,140,31,216,31,193,31,193,30,50,31,50,30,115,31,248,31,177,31,96,31,231,31,190,31,181,31,181,31,181,30,230,31,212,31,35,31,2,31,127,31,37,31,37,30,81,31,4,31,140,31,163,31,63,31,63,30,36,31,12,31,81,31,81,30,159,31,207,31,207,30,164,31,164,30,228,31,32,31,32,30,41,31,228,31,228,30,228,29,228,28,187,31,56,31,131,31,131,30,211,31,205,31,125,31,173,31,187,31,244,31,109,31,194,31,194,30,160,31,75,31,217,31,27,31,13,31,254,31,110,31,110,30,11,31,240,31,117,31,159,31,83,31,207,31,135,31,94,31,23,31,217,31,220,31,184,31,8,31,96,31,113,31,87,31,194,31,59,31,59,30,173,31,71,31,46,31,88,31,206,31,197,31,94,31,114,31,114,31,114,30,215,31,141,31,171,31,218,31,47,31,122,31,122,30,122,29,203,31,203,30,2,31,2,30,180,31,84,31,52,31,173,31,231,31,107,31,138,31,64,31,77,31,77,30,171,31,74,31,74,30,220,31,69,31,69,30,69,29,167,31,65,31,65,30,31,31,2,31,2,30,2,29,2,28,159,31,40,31,40,30,89,31,137,31,183,31,164,31,13,31,13,30,184,31,217,31,179,31,183,31,51,31,95,31,76,31,198,31,55,31,164,31,155,31,155,30,155,29,81,31,6,31,239,31,247,31,197,31,197,30,197,29,197,28,197,27,75,31,75,30,33,31,103,31,158,31,158,30,118,31,127,31,66,31,111,31,177,31,233,31,158,31,56,31,56,30,67,31,67,30,152,31,152,30,43,31,43,30,21,31,101,31,196,31,208,31,208,30,208,29,193,31,95,31,49,31,49,30,241,31,91,31,18,31,200,31,86,31,86,30,167,31,140,31,108,31,67,31,246,31,5,31,5,30,229,31,229,30,229,29,2,31,225,31,173,31,47,31,197,31,228,31,41,31,87,31,83,31,8,31,41,31,158,31,165,31,165,30,254,31,138,31,138,30,135,31,38,31,38,30,149,31,251,31,187,31,68,31,68,30,189,31,99,31,154,31,56,31,31,31,91,31,140,31,109,31,109,30,72,31,27,31,27,30,79,31,37,31,131,31,131,30,85,31,85,30,108,31,52,31,52,30,52,29,247,31,102,31,103,31,70,31,70,30,154,31,147,31,143,31,37,31,37,30,15,31,91,31,203,31,13,31,253,31,253,30,87,31,170,31,170,30,13,31,108,31,49,31,34,31,34,30,101,31,230,31);

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
